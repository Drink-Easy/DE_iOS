// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Then
import CoreModule
import Network

class WineDetailViewController: UIViewController, UIScrollViewDelegate, FirebaseTrackable {
    var screenName: String = Tracking.VC.wineDetailVC
    
    let navigationBarManager = NavigationBarManager()
    public var wineId: Int = 0
    var wineName: String = "Default Name"
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
    var reviewData: [WineReviewModel] = []
    private var expandedCells: [Bool] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = AppColor.grayBG
    
        addView()
        constraints()
        setupNavigationBar()
        setNavBarAppearance(navigationController: self.navigationController)
//        callWineDetailAPI(wineId: self.wineId)
        showLiked()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        callWineDetailAPI(wineId: self.wineId)
        self.view.addSubview(indicator)
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
            textColor: AppColor.black ?? .black
        )
        smallTitleLabel.isHidden = true
        
        navigationBarManager.addRightButton(
            to: navigationItem,
            icon: "heart",
            target: self,
            action: #selector(tappedLiked),
            tintColor: AppColor.purple100!
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
        sender.isSelected.toggle()
        isLiked.toggle()
        updateHeartButton(button: sender)
    }
    
    private func updateHeartButton(button: UIButton) {
        let heartImage = button.isSelected
            ? UIImage(systemName: "heart.fill")?.withTintColor(AppColor.purple100!, renderingMode: .alwaysOriginal)
            : UIImage(systemName: "heart")?.withTintColor(AppColor.purple100!, renderingMode: .alwaysOriginal)

        button.setImage(heartImage, for: .normal)
        button.tintColor = .clear
    }
    
//    private lazy var largeTitleLabel = UILabel().then {
//        $0.font = UIFont.ptdSemiBoldFont(ofSize: 24)
//        $0.numberOfLines = 0
//        $0.textColor = AppColor.black
//    }
    
    private lazy var largeTitleLabel = UILabel().then {
        let text = wineName
        $0.numberOfLines = 0
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.ptdSemiBoldFont(ofSize: 24),
            .paragraphStyle: paragraphStyle,
            .foregroundColor: AppColor.black!
        ]
        
        $0.attributedText = NSAttributedString(string: text, attributes: attributes)
    }
    
    private var smallTitleLabel = UILabel()
    
    private lazy var scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
    }
    
    //largeTitle -> smallTitle
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let largeTitleBottom = largeTitleLabel.frame.maxY + 5
        
        UIView.animate(withDuration: 0.1) {
            self.largeTitleLabel.alpha = offsetY > largeTitleBottom ? 0 : 1
            self.smallTitleLabel.isHidden = !(offsetY > largeTitleBottom)
        }
    }
    
    private lazy var contentView = UIView()
    
    private var wineDetailView = WineDetailView()
    private var vivinoRateView = VivinoRateView()
    private var averageTastingNoteView = AverageTastingNoteView()
    
    private lazy var reviewView = ReviewView().then {
        $0.reviewCollectionView.delegate = self
        $0.reviewCollectionView.dataSource = self
        $0.moreBtn.addTarget(self, action: #selector(goToEntireReview), for: .touchUpInside)
    }
    
    @objc
    private func goToEntireReview() {
        let vc = EntireReviewViewController()
        vc.wineId = self.wineId
        vc.wineName = self.wineName
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func addView() {
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [largeTitleLabel, wineDetailView, vivinoRateView, averageTastingNoteView, reviewView].forEach{ contentView.addSubview($0) }
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
            $0.top.equalToSuperview().offset(10)
        }
        
        wineDetailView.snp.makeConstraints {
            $0.top.equalTo(largeTitleLabel.snp.bottom).offset(21)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        vivinoRateView.snp.makeConstraints {
            $0.top.equalTo(wineDetailView.snp.bottom).offset(54)
            $0.horizontalEdges.equalToSuperview()
        }
        
        averageTastingNoteView.snp.makeConstraints { 
            $0.top.equalTo(vivinoRateView.snp.bottom).offset(70)
            $0.horizontalEdges.equalToSuperview()
        }
        
        reviewView.snp.makeConstraints {
            $0.top.equalTo(averageTastingNoteView.snp.bottom).offset(55)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-40)
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
        
        DispatchQueue.main.async {
            //self.setupNavigationBar() // 제목 및 좋아요 설정
            self.updateReviewView()
        }
        
        let infoData = WineDetailInfoModel(image: wineResponse.imageUrl, sort: wineResponse.sort, country: wineResponse.country, region: wineResponse.region, variety: wineResponse.variety)
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
                } else {
                    print("작성된 리뷰가 없습니다.")
                }
            }
            expandedCells = Array(repeating: false, count: self.reviewData.count)
        }
        DispatchQueue.main.async {
            self.wineDetailView.configure(infoData)
            self.vivinoRateView.configure(rateData)
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
                    if let data = responseData {
                        self.transformResponseData(data)
                    }
                    self.view.hideBlockingView()
                }
            } catch {
                self.view.hideBlockingView()
                print(error.localizedDescription)
            }
        }
    }
    
    
    func callLikeAPI(wineId: Int) async {
        self.view.showBlockingView()
        do {
            let responseData = try await likedNetworkService.postWishlist(wineId: wineId)
            self.view.hideBlockingView()
        } catch {
            print("❌ 좋아요 API 호출 실패: \(error.localizedDescription)")
            self.view.hideBlockingView()
        }
    }
    
    func calldeleteLikedAPI(wineId: Int) async {
        self.view.showBlockingView()
        do {
            let responseData = try await likedNetworkService.deleteWishlist(wineId: wineId)
            self.view.hideBlockingView()
        } catch {
            print("❌ 좋아요 API 호출 실패: \(error.localizedDescription)")
            self.view.hideBlockingView()
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
        let labelFont = UIFont.ptdMediumFont(ofSize: 14)
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
