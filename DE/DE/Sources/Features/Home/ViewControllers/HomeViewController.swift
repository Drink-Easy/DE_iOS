// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Then
import Network
import SafariServices

public class HomeViewController: UIViewController, HomeTopViewDelegate, UIGestureRecognizerDelegate {
    
    private var adImage: [HomeBannerModel] = []
    var recommendWineDataList: [HomeWineModel] = []
    var popularWineDataList: [HomeWineModel] = []
    
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
            guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
                print("⚠️ userId가 UserDefaults에 없습니다.")
                return
            }
            self.view.showBlockingView()
            
            do {
                // 캐시 데이터 사용 시도
                self.userName = try await PersonalDataManager.shared.fetchUserName(for: userId)
                self.view.hideBlockingView()
            } catch {
                do {
                    // get api 사용 시도 -> 캐시 데이터 업데이트
                    self.userName = try await memberService.getUserName()
                    
                    try await PersonalDataManager.shared.updatePersonalData(for: userId, userName: self.userName)
                    
                    self.view.hideBlockingView()
                } catch {
                    print(error.localizedDescription)
                }
                print(error.localizedDescription)
                self.view.hideBlockingView()
            }
        }
    }
    
    @objc
    private func goToMoreLikely() {
        let vc = MoreLikelyWineViewController()
        vc.userName = self.userName
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
        let vc = MorePopularWineViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        addComponents()
        constraints()
        startAutoScrolling()
        pageControlNumberView.totalPages = adImage.count
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.view.addSubview(indicator)
        fetchName()
        
        setAdBanner()
        fetchWines(isRecommend: true) // 추천 와인
        fetchWines(isRecommend: false) // 인기 와인
        
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
    
    // MARK: - 컬렉션뷰 업데이트 함수
    func updateCollectionView(isRecommend : Bool, with wines: [WineData]) {
        DispatchQueue.main.async {
            let maxDisplayCount = 5
            let homeWineModels = self.toHomeWineModels(Array(wines.prefix(maxDisplayCount)))
            
            if isRecommend {
                self.recommendWineDataList = homeWineModels
                self.likeWineListView.recomCollectionView.reloadData()
            } else { // 인기 와인인 경우
                self.popularWineDataList = homeWineModels
                self.popularWineListView.recomCollectionView.reloadData()
            }
        }
    }
    
    // MARK: - WineData → HomeWineModel 변환
    func toHomeWineModel(_ wine: WineData) -> HomeWineModel {
        return HomeWineModel(
            wineId: wine.wineId,
            imageUrl: wine.imageUrl,
            wineName: wine.wineName,
            sort: wine.sort,
            price: wine.price,
            vivinoRating: wine.vivinoRating
        )
    }
    
    func toHomeWineModels(_ wines: [WineData]) -> [HomeWineModel] {
        return wines.map { toHomeWineModel($0) }
    }
    
    func fetchWines(isRecommend : Bool) {
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
            print("⚠️ userId가 UserDefaults에 없습니다.")
            return
        }
        self.userId = userId
        
        Task {
            do {
                if isRecommend {
                    // 1. 캐시 데이터 우선 사용
                    let cachedWines = try WineDataManager.shared.fetchWineDataList(userId: userId)
                    
                    if !cachedWines.isEmpty {
                        print("✅ 캐시된 추천와인 데이터 사용: \(cachedWines.count)개")
                        updateCollectionView(isRecommend: isRecommend, with: cachedWines) // ✅ 추가
                        return
                    }
                    
                    self.updateCollectionView(isRecommend: isRecommend, with: cachedWines)
                } else { // 인기 와인은 따로 처리
                    let cachedWines = try PopularWineManager.shared.fetchWineDataList()
                    
                    if !cachedWines.isEmpty {
                        print("✅ 캐시된 추천와인 데이터 사용: \(cachedWines.count)개")
                        updateCollectionView(isRecommend: isRecommend, with: cachedWines) // ✅ 추가
                        return
                    }
                    self.updateCollectionView(isRecommend: isRecommend, with: cachedWines)
                }
            } catch {
                print("⚠️ 캐시된 데이터 없음")
            }
            
            // 2. 캐시 데이터가 없으면 네트워크 요청
            print("🌐 네트워크 요청 시작")
            await fetchWinesFromNetwork(isRecommend)
        }
    }

    // MARK: - 네트워크 요청 처리
    func setAdBanner() {
        Task {
            do {
                let cacheData = try AdBannerListManager.shared.fetchAdBannerList() // 내부에서 만료 체크함
                print("✅ 캐시 데이터 사용!")
                
                let bannerModels = cacheData.map { HomeBannerModel(imageUrl: $0.imageUrl, postUrl: $0.postUrl) }
                
                DispatchQueue.main.async {
                    self.adImage = bannerModels
                    self.adCollectionView.reloadData()
                    self.pageControlNumberView.totalPages = self.adImage.count
                }

            } catch {
                print("⚠️ 캐시 데이터 없음 → 네트워크 요청 수행")
                self.view.showBlockingView()
                do {
                    let newData = try await fetchHomeBanner()
                    try AdBannerListManager.shared.saveAdBannerList(
                        bannerData: newData.map { AdBannerDataModel(bannerId: $0.bannerId, imageUrl: $0.imageUrl, postUrl: $0.postUrl) },
                        expirationDate: Date()
                    )
                    self.view.hideBlockingView()
                    
                } catch {
                    print("❌ 네트워크 요청 실패: \(error)")
                    self.view.hideBlockingView()
                }
            }
        }
    }
    
    private func fetchHomeBanner() async throws -> [BannerResponse] {
        let response = try await bannerNetworkService.fetchHomeBanner()

        //UI 업데이트는 메인 스레드에서 수행
        DispatchQueue.main.async {
            self.adImage = response.bannerResponseList.map {
                HomeBannerModel(imageUrl: $0.imageUrl, postUrl: $0.postUrl)
            }
            self.pageControlNumberView.totalPages = self.adImage.count
            self.adCollectionView.reloadData()
        }
        return response.bannerResponseList
    }
    
    private func fetchWinesFromNetwork(_ isRecommend: Bool) async {
        self.view.showBlockingView()
        
        if isRecommend {
            do {
                let responseData = try await networkService.fetchRecommendWines()
                await self.processWineData(isRecommend, responseData: responseData.0, time: responseData.1 ?? 3600)
                DispatchQueue.main.async {
                    self.view.hideBlockingView()
                }
            } catch {
                print("❌ 네트워크 오류 발생: \(error.localizedDescription)")
                self.view.hideBlockingView()
            }
        } else { // 인기 와인인 경우
            do {
                let responseData = try await networkService.fetchPopularWines()
                await self.processWineData(isRecommend, responseData: responseData.0, time: responseData.1 ?? 3600)
                DispatchQueue.main.async {
                    self.view.hideBlockingView()
                }
            } catch {
                print("❌ 네트워크 오류 발생: \(error.localizedDescription)")
                self.view.hideBlockingView()
            }
        }
    }
    
    private func processWineData(_ isRecommend: Bool, responseData: [HomeWineDTO], time: TimeInterval) async {
        let wines = responseData.map {
            WineData(wineId: $0.wineId,
                     imageUrl: $0.imageUrl,
                     wineName: $0.wineName,
                     sort: $0.sort,
                     price: $0.price,
                     vivinoRating: $0.vivinoRating)
        }
        
        do {
            guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
                print("⚠️ userId가 UserDefaults에 없습니다.")
                return
            }
            if isRecommend {
                try WineDataManager.shared.saveWineData(userId: userId, wineData: wines, expirationInterval: time)
                print("✅ 추천 와인 저장 완료: \(wines.count)개")
                
            } else { // 인기 와인은 다른 데이터 매니저 사용
                try PopularWineManager.shared.saveWineData(wineData: wines, expirationInterval: time)
                print("인기 와인 저장 완료: \(wines.count)개")
            }
            updateCollectionView(isRecommend: isRecommend, with: wines)
        } catch {
            print("❌ 데이터 저장 중 오류 발생: \(error)")
        }
    }
    
    private func updateLikeWineListView() {
        likeWineListView.title.text = "For \(userName),"
        likeWineListView.title.setPartialTextStyle(
            text: likeWineListView.title.text ?? "",
            targetText: "\(userName),",
            color: AppColor.purple100 ?? .purple,
            font: UIFont.ptdSemiBoldFont(ofSize: 26)
        )
    }
    
    func didTapSearchButton() {
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
            let vc = WineDetailViewController()
            vc.wineId = (collectionView.tag == 1) ? recommendWineDataList[indexPath.row].wineId : popularWineDataList[indexPath.row].wineId
            vc.wineName = (collectionView.tag == 1) ? recommendWineDataList[indexPath.row].wineName : popularWineDataList[indexPath.row].wineName
            navigationController?.pushViewController(vc, animated: true)
        } else if collectionView.tag == 0 {
            print("\(adImage[indexPath.row].postUrl) : 이 주소로 이동하세요")
            
            // 사파리 뷰 띄우는거 주석 해제만 하면 됨! by dyk.
//            if let url = URL(string: adImage[indexPath.row].postUrl) {
//                let safariVC = SFSafariViewController(url: url)
//                present(safariVC, animated: true, completion: nil)
//            }
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
