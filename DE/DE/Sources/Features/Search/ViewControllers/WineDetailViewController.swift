// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Then
import CoreModule
import DesignSystem
import Network

class WineDetailViewController: UIViewController, UIScrollViewDelegate, FirebaseTrackable {
    var screenName: String = Tracking.VC.wineDetailVC
    
    let navigationBarManager = NavigationBarManager()
    public var wineId: Int = 0
    var wineName: String = "" {
        didSet {
            AppTextStyle.KR.head.apply(to: largeTitleLabel, text: wineName, color: AppColor.black)
        }
    }
    var wineInfoForTN : WineDetailInfoModel?
    
    var isLiked: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.showLiked()
            }
        }
    }
    var originalIsLiked: Bool = false
    let wineNetworkService = WineService()
    let likedNetworkService = WishlistService()
    private let errorHandler = NetworkErrorHandler()
    
    var reviewData: [WineReviewModel] = []
    private var expandedCells: [Bool] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = AppColor.background
        
        addButtonTarget()
        addView()
        constraints()
        setupNavigationBar()
        setNavBarAppearance(navigationController: self.navigationController)
        showLiked()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(indicator)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        callWineDetailAPI(wineId: self.wineId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        Task {
            if originalIsLiked != isLiked {
                if originalIsLiked {
                    await calldeleteLikedAPI(wineId: wineId)
                } else {
                    await callLikeAPI(wineId: wineId)
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
    }
    
    func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC)
        )
        
        smallTitleLabel = navigationBarManager.setNReturnTitle(
            to: navigationItem,
            title: wineName,
            textColor: AppColor.black
        )
        smallTitleLabel.isHidden = true
        
        navigationBarManager.addRightButton(
            to: navigationItem,
            icon: SearchConstants.emptyHeartIcon,
            target: self,
            action: #selector(tappedLiked),
            tintColor: AppColor.purple100
        )
    }
    
    private func showLiked() {
        DispatchQueue.main.async {
            if let rightButton = self.navigationItem.rightBarButtonItem?.customView as? UIButton {
                rightButton.isSelected = self.isLiked
                self.updateHeartButton(button: rightButton)
            }
        }
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func tappedLiked(_ sender: UIButton) {
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.likeBtnTapped, fileName: #file)
        sender.isSelected.toggle()
        isLiked.toggle()
        updateHeartButton(button: sender)
    }
    
    private func updateHeartButton(button: UIButton) {
        let heartImage = button.isSelected
        ? UIImage(systemName: SearchConstants.fillHeartIcon)?
            .withTintColor(AppColor.purple100, renderingMode: .alwaysOriginal)
        : UIImage(systemName: SearchConstants.emptyHeartIcon)?
            .withTintColor(AppColor.purple100, renderingMode: .alwaysOriginal)

        button.setImage(heartImage, for: .normal)
        button.tintColor = .clear
    }
    
    private lazy var largeTitleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.isHidden = true
    }
    
    private var smallTitleLabel = UILabel()
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    //largeTitle -> smallTitle
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let largeTitleBottom = wineInfoView.wineInfo.largeTitleLabel.frame.maxY + 5
        
        UIView.animate(withDuration: 0.1) {
            self.largeTitleLabel.alpha = offsetY > largeTitleBottom ? 0 : 1
            self.smallTitleLabel.isHidden = !(offsetY > largeTitleBottom)
        }
    }
    
    private lazy var contentView = UIView()
    
    private var wineInfoView = NewWineInfoView()
    private var vintageInfoView = VintageInfoView(tabAction: {
        print("빈티지 버튼 클릭")
    })
    private var wineDetailsView = WineDetailsView()
    private var averageTastingNoteView = AverageTastingNoteView()
    private lazy var reviewView = ReviewView().then {
        $0.reviewCollectionView.delegate = self
        $0.reviewCollectionView.dataSource = self
    }
    
    let divider1 = DividerFactory.make()
    let divider2 = DividerFactory.make()
    let divider3 = DividerFactory.make()
    let thinDivider = DividerFactory.make()
    
    private func addButtonTarget() {
        averageTastingNoteView.writeNewTastingNoteBtn.addTarget(self, action: #selector(goToTastingNote), for: .touchUpInside)
        reviewView.moreBtn.addTarget(self, action: #selector(goToEntireReview), for: .touchUpInside)
    }
    
    @objc
    private func goToTastingNote() {
        // 배정이 안되서 일단 비활성화 해둠!!
        // TODO : 나중에 파이어베이스
//        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.moreBtnTapped, fileName: #file)
        
        let vc = TastedDateViewController()
        vc.hidesBottomBarWhenPushed = true
        
        guard let wineInfo = wineInfoForTN else {
            self.showToastMessage(message: "테이스팅 노트 작성을 위한 와인 데이터를 생성하는데 실패했습니다.", yPosition: view.frame.height * 0.75)
            return
        }
        
        TNWineDataManager.shared.updateWineData(wineId: self.wineId,
                                                wineName: self.wineName,
                                                sort: wineInfo.sort,
                                                country: wineInfo.country,
                                                region: wineInfo.region,
                                                imageUrl: wineInfo.image,
                                                variety: wineInfo.variety
        )
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func goToEntireReview() {
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.moreBtnTapped, fileName: #file)
        
        let vc = EntireReviewViewController()
        vc.wineId = self.wineId
        vc.wineName = self.wineName
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func addView() {
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(largeTitleLabel, wineInfoView, vintageInfoView, wineDetailsView, averageTastingNoteView, reviewView, divider1, divider2, divider3, thinDivider)
    }
    
    private func constraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView.snp.width)
            $0.bottom.equalTo(reviewView.snp.bottom).offset(40)
        }
        
        largeTitleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(25)
//            $0.top.equalToSuperview().offset(10)
        }
        
        wineInfoView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
        }
        
        divider1.snp.makeConstraints {
            $0.top.equalTo(wineInfoView.snp.bottom)
            $0.height.equalTo(8)
            $0.horizontalEdges.equalToSuperview()
        }
        
        vintageInfoView.snp.makeConstraints {
            $0.top.equalTo(divider1)
            $0.horizontalEdges.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
        }
        
        divider2.snp.makeConstraints {
            $0.top.equalTo(vintageInfoView.snp.bottom)
            $0.height.equalTo(8)
            $0.horizontalEdges.equalToSuperview()
        }
        
        wineDetailsView.snp.makeConstraints {
            $0.top.equalTo(divider2.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
        }
        
        thinDivider.snp.makeConstraints {
            $0.top.equalTo(wineDetailsView.snp.bottom)
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
        }
        
        averageTastingNoteView.snp.makeConstraints {
            $0.top.equalTo(thinDivider.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
        }
        
        divider3.snp.makeConstraints {
            $0.top.equalTo(averageTastingNoteView.snp.bottom)
            $0.height.equalTo(8)
            $0.horizontalEdges.equalToSuperview()
        }
        
        reviewView.snp.makeConstraints {
            $0.top.equalTo(averageTastingNoteView.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
            $0.bottom.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
        }
    }
    
    private func updateReviewView() {
        if reviewData.isEmpty {
            // 리뷰가 없을 때
            reviewView.moreBtn.isHidden = true
            reviewView.reviewCollectionView.isHidden = true
            reviewView.reviewCollectionView.snp.updateConstraints {
                $0.height.equalTo(0) // 높이를 0으로 설정
            }
            reviewView.scoreLabel.isHidden = true
            reviewView.noReviewLabel.isHidden = false
        } else {
            // 리뷰가 있을 때
            reviewView.moreBtn.isHidden = false
            reviewView.reviewCollectionView.isHidden = false
            reviewView.scoreLabel.isHidden = false
            reviewView.noReviewLabel.isHidden = true
        }
    }
    
    func transformResponseData(_ responseData : WineResponseWithThreeReviewsDTO) {
        let wineResponse = responseData.wineInfoResponse
        self.wineId = wineResponse.wineId
        self.wineName = wineResponse.name
        self.isLiked = wineResponse.liked
        self.originalIsLiked = wineResponse.liked
        let noseNotes = [
            wineResponse.nose1,
            wineResponse.nose2,
            wineResponse.nose3
        ].compactMap { $0 }

        let tastingNoteString = noseNotes.joined(separator: ", ")
        
        DispatchQueue.main.async { [weak self] in
            //self.setupNavigationBar() // 제목 및 좋아요 설정
            self?.updateReviewView()
        }
        
        let infoData = WineDetailInfoModel(wineName:wineResponse.name, rating:wineResponse.vivinoRating, image: wineResponse.imageUrl, sort: wineResponse.sort, country: wineResponse.country, region: wineResponse.region, variety: wineResponse.variety)
        let rateData = WineViVinoRatingModel(vivinoRating: wineResponse.vivinoRating)
        let avgData = WineAverageTastingNoteModel(wineNoseText: tastingNoteString, avgSugarContent: wineResponse.avgSweetness, avgAcidity: wineResponse.avgAcidity, avgTannin: wineResponse.avgTannin, avgBody: wineResponse.avgBody, avgAlcohol: wineResponse.avgAlcohol)
        let roundedAvgMemberRating = (wineResponse.avgMemberRating * 10).rounded() / 10
        let reviewData = WineAverageReviewModel(avgMemberRating: roundedAvgMemberRating)
        
        if let reviewResponse = responseData.recentReviews {
            for data in reviewResponse {
                if let name = data.name,
                   let review = data.review,
                   let rating = data.rating,
                   let createdAt = data.createdAt {
                    let reviewModel = WineReviewModel(name: name, contents: review, rating: rating, createdAt: createdAt)
                    self.reviewData.append(reviewModel)
                }
            }
            expandedCells = Array(repeating: false, count: self.reviewData.count)
        }
        
        DispatchQueue.main.async {
//            AppTextStyle.KR.head.apply(to: self.largeTitleLabel, text: self.wineName, color: AppColor.black)
            self.wineInfoForTN = infoData // 테이스팅 노트 작성을 위한 데이터 저장
            self.wineInfoView.configure(infoData)
            self.wineDetailsView.configure(infoData)
            self.averageTastingNoteView.configure(avgData)
            self.reviewView.configure(reviewData)
            self.reviewView.reviewCollectionView.reloadData()
        }
    }
    
    func callWineDetailAPI(wineId: Int) {
        self.view.showColorBlockingView()
        Task {
            do {
                let responseData = try await wineNetworkService.fetchWineInfo(wineId: wineId)
                DispatchQueue.main.async {
                    self.reviewData.removeAll()
                    if let data = responseData {
                        self.transformResponseData(data)
                    }
                    self.view.hideBlockingView()
                }
            } catch {
                self.view.hideBlockingView()
                errorHandler.handleNetworkError(error, in: self)
            }
        }
    }
    
    
    func callLikeAPI(wineId: Int) async {
        self.view.showBlockingView()
        do {
            let _ = try await likedNetworkService.postWishlist(wineId: wineId)
            self.view.hideBlockingView()
        } catch {
            self.view.hideBlockingView()
            errorHandler.handleNetworkError(error, in: self)
        }
    }
    
    func calldeleteLikedAPI(wineId: Int) async {
        self.view.showBlockingView()
        do {
            let _ = try await likedNetworkService.deleteWishlist(wineId: wineId)
            self.view.hideBlockingView()
        } catch {
            self.view.hideBlockingView()
            errorHandler.handleNetworkError(error, in: self)
        }
    }
    
    private func updateScrollViewHeight() {
        DispatchQueue.main.async {
            // reviewView의 동적 높이 구하기
            let collectionViewContentHeight = self.reviewView.reviewCollectionView.collectionViewLayout.collectionViewContentSize.height
            
            // contentView의 bottom 업데이트
            self.contentView.snp.updateConstraints {
                $0.bottom.equalTo(self.reviewView.snp.bottom).offset(40)
            }
            
            // 컬렉션뷰의 height 업데이트
            self.reviewView.reviewCollectionView.snp.updateConstraints {
                $0.height.equalTo(collectionViewContentHeight)
            }
            
            // scrollView의 contentSize 수동 업데이트
            self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: self.contentView.frame.height + collectionViewContentHeight + 40)
            
            self.scrollView.layoutIfNeeded()
        }
    }
}

extension WineDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReviewCollectionViewCell.identifier, for: indexPath) as! ReviewCollectionViewCell
        
        let review = reviewData[indexPath.item]
        cell.configure(model: review, isExpanded: expandedCells[indexPath.item])
        
        cell.onToggle = {
            self.expandedCells[indexPath.item].toggle()
            
            UIView.animate(withDuration: 0, animations: {
                collectionView.performBatchUpdates(nil, completion: nil)
                self.updateScrollViewHeight()
            })
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width
        let text = reviewData[indexPath.item].contents
        let isExpanded = expandedCells[indexPath.item]
        
        // 텍스트 높이 계산 + 패딩
        let labelFont = UIFont.pretendard(.medium, size: 14)
        let lineSpacing = labelFont.pointSize * 0.3
        let labelWidth = width - 30
        //let estimatedHeight = text.heightWithConstrainedWidth(width: labelWidth, font: labelFont)
        let numberOfLines = text.numberOfLines(width: labelWidth, font: labelFont, lineSpacing: lineSpacing)
        let lineHeight = labelFont.lineHeight + lineSpacing
        
        let cellHeight = isExpanded
                ? CGFloat(numberOfLines - 2) * lineHeight + 104
                : 104
        return CGSize(width: width, height: cellHeight)
    }
}
