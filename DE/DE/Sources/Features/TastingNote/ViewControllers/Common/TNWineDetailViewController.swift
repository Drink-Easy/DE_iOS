// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Then
import CoreModule
import DesignSystem
import Network

class TNWineDetailViewController: UIViewController, UIScrollViewDelegate, FirebaseTrackable {
    var screenName: String = Tracking.VC.wineDetailVC
    
    let navigationBarManager = NavigationBarManager()
    public var wineId: Int = 0
    var wineName: String = "" {
        didSet {
            AppTextStyle.KR.head.apply(to: largeTitleLabel, text: wineName, color: AppColor.black)
        }
    }
    let wineData = TNWineDataManager.shared
    let tnManager = NewTastingNoteManager.shared
    
    var isLiked: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.showLiked()
            }
        }
    }
    var originalIsLiked: Bool = false
    let likedNetworkService = WishlistService()
    private let errorHandler = NetworkErrorHandler()
    
    var reviewData: [WineReviewModel] = []
    private var expandedCells: [Bool] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = AppColor.background
        averageTastingNoteView.writeNewTastingNoteBtn.isHidden = true
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
        self.transformResponseData()
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
    
    let divider1 = DividerFactory.make()
    let divider2 = DividerFactory.make()
    let divider3 = DividerFactory.make()
    let thinDivider = DividerFactory.make()
    
    private func addView() {
        scrollView.delegate = self
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubviews(largeTitleLabel, wineInfoView, vintageInfoView, wineDetailsView, averageTastingNoteView, divider1, divider2, thinDivider)
    }
    
    private func constraints() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView.snp.width)
            $0.bottom.equalTo(averageTastingNoteView.snp.bottom).offset(40)
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
    }

    func transformResponseData() {
        let wineResponse = wineData
        let tnResponse = tnManager
        self.wineId = wineResponse.wineId
        self.wineName = wineResponse.wineName
        let noseNotes = formatNoseList(tnManager.nose)

        let infoData = WineDetailInfoModel(wineName:wineResponse.wineName, rating:tnResponse.rating, image: wineResponse.imageUrl, sort: wineResponse.sort, country: wineResponse.country, region: wineResponse.region, variety: wineResponse.variety)
        let rateData = WineViVinoRatingModel(vivinoRating: tnResponse.rating)
        let avgData = WineAverageTastingNoteModel(wineNoseText: noseNotes, avgSugarContent: Double(tnResponse.sugarContent), avgAcidity: Double(tnResponse.acidity), avgTannin: Double(tnResponse.tannin), avgBody: Double(tnResponse.body), avgAlcohol: Double(tnResponse.alcohol))

        DispatchQueue.main.async {
            self.wineInfoView.configure(infoData)
            self.wineDetailsView.configure(infoData)
            self.averageTastingNoteView.configure(avgData)
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
}
