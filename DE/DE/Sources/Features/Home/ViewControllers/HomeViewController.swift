// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Then
import Network
import SafariServices
import AppTrackingTransparency

public class HomeViewController: UIViewController, HomeTopViewDelegate, UIGestureRecognizerDelegate, FirebaseTrackable {
    public var screenName: String = Tracking.VC.homeViewController
    
    public static var isTrackingOn : Bool?
    
    private var adImage: [HomeBannerModel] = []
    var recommendWineDataList: [HomeWineModel] = []
    var popularWineDataList: [HomeWineModel] = []
    
    var allRecommendWineDataList: [HomeWineModel] = []
    var allPopularWineDataList: [HomeWineModel] = []
    
    private let maxShowWineCount = 5
    public var userId : Int?
    
    public var userName: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.updateLikeWineListView()
            }
        }
    }
    
    private var homeTopView = HomeTopView()
    let networkService = WineService()
    let bannerNetworkService = NoticeService()
    let memberService = MemberService()
    private let errorHandler = NetworkErrorHandler()
    
    // View 세팅
    private lazy var scrollView: UIScrollView = {
        let s = UIScrollView()
        s.showsVerticalScrollIndicator = false
        //s.showsHorizontalScrollIndicator = false
        return s
    }()
    
    private lazy var contentView: UIView = {
        let v = UIView()
        return v
    }()
    
    private lazy var adCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.minimumInteritemSpacing = 0
        $0.minimumLineSpacing = 0
        $0.scrollDirection = .horizontal
    }).then {
        $0.register(AdCollectionViewCell.self, forCellWithReuseIdentifier: AdCollectionViewCell.identifier)
        $0.backgroundColor = .clear
        $0.isPagingEnabled = true
        $0.isScrollEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.delegate = self
        $0.dataSource = self
        $0.tag = 0
    }
    
    private lazy var pageControlNumberView = PageControlNumberView()
    
    private lazy var likeWineListView = RecomView().then {
        $0.title.text = "For \(userName),"
        $0.title.setPartialTextStyle(text: $0.title.text ?? "", targetText: "\(userName),", color: AppColor.purple100 ?? .purple, font: UIFont.ptdSemiBoldFont(ofSize: 26))
        $0.recomCollectionView.delegate = self
        $0.recomCollectionView.dataSource = self
        $0.recomCollectionView.tag = 1
        $0.moreBtn.addTarget(self, action: #selector(goToMoreLikely), for: .touchUpInside)
    }
    
    public func fetchName() {
        Task {
            self.view.showBlockingView()
            do {
                self.userName = try await memberService.getUserName()
                self.view.hideBlockingView()
            } catch {
                self.view.hideBlockingView()
                errorHandler.handleNetworkError(error, in: self)
            }
        }
    }
    
    @objc
    private func goToMoreLikely() {
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.moreBtnTapped, fileName: #file)
        let vc = MoreLikelyWineViewController()
        vc.userName = self.userName
        vc.recommendWineDataList = self.allRecommendWineDataList
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private lazy var popularWineListView = RecomView().then {
        $0.title.text = "지금 가장 인기있는 와인 🔥"
        $0.recomCollectionView.delegate = self
        $0.recomCollectionView.dataSource = self
        $0.recomCollectionView.tag = 2
        $0.moreBtn.addTarget(self, action: #selector(goToMorePopular), for: .touchUpInside)
    }
    
    @objc private func goToMorePopular() {
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.moreBtnTapped, fileName: #file)
        let vc = MorePopularWineViewController()
        vc.popularWineDataList = self.allPopularWineDataList
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background
        addComponents()
        constraints()
        startAutoScrolling()
        pageControlNumberView.totalPages = adImage.count
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(indicator)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self

        fetchName()
        
        setAdBanner()
        setWines(isRecommend: true) // 추천 와인
        setWines(isRecommend: false) // 인기 와인
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestTrackingPermission()
        logScreenView(fileName: #file)
    }
    
    private func addComponents() {
        [homeTopView, scrollView].forEach{ view.addSubview($0) }
        scrollView.addSubview(contentView)
        [adCollectionView, pageControlNumberView, likeWineListView, popularWineListView].forEach{ contentView.addSubview($0) }
        homeTopView.delegate = self
    }
    
    private func constraints() {
        homeTopView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(homeTopView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView) // 스크롤뷰의 모든 가장자리에 맞춰 배치
            $0.width.equalTo(scrollView.snp.width) // 가로 스크롤을 방지, 스크롤뷰와 같은 너비로 설정
            $0.bottom.equalTo(popularWineListView.snp.bottom).offset(DynamicPadding.dynamicValue(35))
        }
        
        adCollectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(view.snp.width).multipliedBy(282.0 / 393.0)
        }
        
        pageControlNumberView.snp.makeConstraints {
            $0.bottom.equalTo(adCollectionView.snp.bottom).offset(-DynamicPadding.dynamicValue(15))
            $0.trailing.equalTo(adCollectionView.snp.trailing).offset(-DynamicPadding.dynamicValue(15))
            $0.width.equalTo(DynamicPadding.dynamicValue(66))
            $0.height.equalTo(DynamicPadding.dynamicValue(30))
        }
        
        likeWineListView.snp.makeConstraints {
            $0.top.equalTo(adCollectionView.snp.bottom).offset(DynamicPadding.dynamicValue(35))
            $0.horizontalEdges.equalToSuperview()
        }
        
        popularWineListView.snp.makeConstraints {
            $0.top.equalTo(likeWineListView.snp.bottom).offset(DynamicPadding.dynamicValue(40))
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - 맞춤 광고 서비스 권한 요청 함수
    func requestTrackingPermission() {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                HomeViewController.isTrackingOn = true
            case .denied:
                HomeViewController.isTrackingOn = false
            case .notDetermined:
                print("Tracking 권한 요청 전 상태")
            case .restricted:
                HomeViewController.isTrackingOn = true
            @unknown default:
                print("알 수 없는 상태")
            }
        }
    }
    
    // MARK: - 컬렉션뷰 업데이트 함수
    func updateCollectionView(isRecommend : Bool, with wines: [HomeWineDTO]) {
        DispatchQueue.main.async {
            let maxDisplayCount = 5
            let homeWineModels = self.toHomeWineModels(Array(wines.prefix(maxDisplayCount)))
            
            if isRecommend {
                self.recommendWineDataList = homeWineModels
                self.likeWineListView.recomCollectionView.reloadData()
                self.allRecommendWineDataList = self.toHomeWineModels(wines)
            } else { // 인기 와인인 경우
                self.popularWineDataList = homeWineModels
                self.popularWineListView.recomCollectionView.reloadData()
                self.allPopularWineDataList = self.toHomeWineModels(wines)
            }
        }
    }
    
    // MARK: - WineData → HomeWineModel 변환
    func toHomeWineModel(_ wine: HomeWineDTO) -> HomeWineModel {
        return HomeWineModel(
            wineId: wine.wineId,
            imageUrl: wine.imageUrl,
            wineName: wine.wineName,
            sort: wine.sort,
            price: wine.price,
            vivinoRating: wine.vivinoRating
        )
    }
    
    func toHomeWineModels(_ wines: [HomeWineDTO]) -> [HomeWineModel] {
        return wines.map { toHomeWineModel($0) }
    }
    
    // MARK: - 네트워크 요청 처리
    func setAdBanner() {
        self.view.showBlockingView()
        Task {
            do {
                let _ = try await fetchHomeBanner()
                self.view.hideBlockingView()
            } catch {
                self.view.hideBlockingView()
                errorHandler.handleNetworkError(error, in: self)
            }
        }
    }
    
    private func fetchHomeBanner() async throws -> [BannerResponse] {
        let response = try await bannerNetworkService.fetchHomeBanner()
        
        DispatchQueue.main.async {
            self.adImage = response.bannerResponseList.map {
                HomeBannerModel(imageUrl: $0.imageUrl, postUrl: $0.postUrl)
            }
            self.pageControlNumberView.totalPages = self.adImage.count
            self.adCollectionView.reloadData()
        }
        return response.bannerResponseList
    }
    
    func setWines(isRecommend : Bool) {
        Task {
            do {
                let data = try await fetchWinesFromNetwork(isRecommend) // 데이터 요청
                updateCollectionView(isRecommend: isRecommend, with: data) // UI update(내부에서 처리)
                self.view.hideBlockingView()
            } catch {
                self.view.hideBlockingView()
                errorHandler.handleNetworkError(error, in: self)
            }
        }
    }
    
    private func fetchWinesFromNetwork(_ isRecommend: Bool) async throws -> [HomeWineDTO] {
        if isRecommend {
            let responseData = try await networkService.fetchRecommendWines()
            return responseData.0
        } else { // 인기 와인인 경우
            let responseData = try await networkService.fetchPopularWines()
            return responseData.0
        }
    }
    
    private func updateLikeWineListView() {
        likeWineListView.title.text = "For \(userName),"
        likeWineListView.title.setPartialTextStyle(
            text: likeWineListView.title.text ?? "",
            targetText: "\(userName),",
            color: AppColor.purple100 ?? .purple,
            font: UIFont.pretendard(.semiBold, size: 26)
        )
    }
    
    func didTapSearchButton() {
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.searchBtnTapped, fileName: #file)
        let searchVC = SearchHomeViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == adCollectionView else { return }
        
        let pageIndex = Int(scrollView.contentOffset.x / view.frame.width)
        pageControlNumberView.currentPage = pageIndex + 1
        
        if pageIndex == 0 && scrollView.contentOffset.x < 0 {
            scrollView.contentOffset.x = 0
        }
        if pageIndex == adImage.count - 1 {
            let maxOffsetX = CGFloat(adImage.count - 1) * view.frame.width
            if scrollView.contentOffset.x > maxOffsetX {
                scrollView.contentOffset.x = maxOffsetX
            }
        }
    }
    
    public func startAutoScrolling() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            self.autoScrollCollectionView()
        }
    }
    
    private func autoScrollCollectionView() {
        guard !adImage.isEmpty else { return }
        
        let currentIndex = Int(adCollectionView.contentOffset.x / view.frame.width)
        let nextIndex = (currentIndex + 1) % adImage.count // 다음 페이지 계산 (마지막 이후 첫 번째로 돌아감)
        
        let nextOffset = CGPoint(x: CGFloat(nextIndex) * view.frame.width, y: 0)
        adCollectionView.setContentOffset(nextOffset, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didEndDecelerating scrollView: UIScrollView) {
        if collectionView.tag == 0 { // ✅ 광고 컬렉션 뷰만 반응
            let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
            pageControlNumberView.currentPage = pageIndex + 1
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return adImage.count
        } else if collectionView.tag == 1 {
            return min(maxShowWineCount, recommendWineDataList.count)
        } else if collectionView.tag == 2 {
            return min(maxShowWineCount, popularWineDataList.count)
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdCollectionViewCell.identifier, for: indexPath) as! AdCollectionViewCell
            
            cell.configure(model: adImage[indexPath.item])
            
            return cell
            
        } else if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecomCollectionViewCell.identifier, for: indexPath) as! RecomCollectionViewCell
            
            // ✅ 안전 처리
            guard indexPath.row < recommendWineDataList.count else { return UICollectionViewCell() }
            
            let wine = recommendWineDataList[indexPath.row]
            let aroundPrice = "\(wine.price / 10000)"
            
            cell.configure(imageURL: wine.imageUrl, score: "\(wine.vivinoRating)", price: aroundPrice, name: wine.wineName, kind: wine.sort)
            
            return cell
            
        } else if collectionView.tag == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecomCollectionViewCell.identifier, for: indexPath) as! RecomCollectionViewCell
            // ✅ 안전 처리
            guard indexPath.row < popularWineDataList.count else { return UICollectionViewCell() }
            
            let wine = popularWineDataList[indexPath.row]
            let aroundPrice = "\(wine.price / 10000)"
            
            cell.configure(imageURL: wine.imageUrl, score: "\(wine.vivinoRating)", price: aroundPrice, name: wine.wineName, kind: wine.sort)
            return cell
            
        }
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1 || collectionView.tag == 2 {
            logCellClick(screenName: screenName, indexPath: indexPath, cellName: Tracking.CellEvent.homeWineCellTapped, fileName: #file, cellID: RecomCollectionViewCell.identifier)
            
            let vc = WineDetailViewController()
            vc.wineId = (collectionView.tag == 1) ? recommendWineDataList[indexPath.row].wineId : popularWineDataList[indexPath.row].wineId
            vc.wineName = (collectionView.tag == 1) ? recommendWineDataList[indexPath.row].wineName : popularWineDataList[indexPath.row].wineName
            navigationController?.pushViewController(vc, animated: true)
        } else if collectionView.tag == 0 {
            logCellClick(screenName: screenName, indexPath: indexPath, cellName: Tracking.CellEvent.adBannerCellTapped, fileName: #file, cellID: AdCollectionViewCell.identifier)

            if let url = URL(string: adImage[indexPath.row].postUrl) {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView.tag == 0 {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else if collectionView.tag == 1 || collectionView.tag == 2 {
            return CGSize(width: 166, height: 205)
        }
        return CGSize.zero
    }
}
