// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Then
import Network
import SearchModule

public class HomeViewController: UIViewController, HomeTopViewDelegate {
    
    private var adImage: [String] = ["ad4", "ad3", "ad2", "ad1"]
    var recommendWineDataList: [HomeWineModel] = []
    var popularWineDataList: [HomeWineModel] = []
    
    private let maxShowWineCount = 5
    
    public var userName: String = "" {
        didSet {
            updateLikeWineListView()
        }
    }
    
    private var homeTopView = HomeTopView()
    let dataManger = WineDataManager.shared
    let networkService = WineService()
    
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
    
    private lazy var pageControl = CustomPageControl(indicatorColor: UIColor(hex: "#D9D9D9") ?? .lightGray, currentIndicatorColor: AppColor.purple50 ?? .purple).then {
        $0.numberOfPages = adImage.count
        $0.currentPage = 0
    }
    
    private lazy var likeWineListView = RecomView().then {
        $0.title.text = "\(userName) 님이 좋아할 만한 와인"
        $0.title.setPartialTextStyle(text: $0.title.text ?? "", targetText: "\(userName)", color: AppColor.purple100 ?? .purple, font: UIFont.ptdSemiBoldFont(ofSize: 26))
        $0.recomCollectionView.delegate = self
        $0.recomCollectionView.dataSource = self
        $0.recomCollectionView.tag = 1
    }
    
    private lazy var popularWineListView = RecomView().then {
        $0.title.text = "지금 가장 인기있는 와인 🔥"
        $0.recomCollectionView.delegate = self
        $0.recomCollectionView.dataSource = self
        $0.recomCollectionView.tag = 2
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        
        addComponents()
        constraints()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        fetchWines(type: .recommended)
        fetchWines(type: .popular)
    }
    
    private func addComponents() {
        [homeTopView, scrollView].forEach{ view.addSubview($0) }
        scrollView.addSubview(contentView)
        [adCollectionView, pageControl, likeWineListView, popularWineListView].forEach{ contentView.addSubview($0) }
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
            $0.bottom.equalTo(popularWineListView.snp.bottom).offset(46)
            
        }
        
        adCollectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(view.snp.width).multipliedBy(282.0 / 393.0)
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(adCollectionView.snp.bottom).inset(20)
            //$0.width.equalTo(200)
        }
        
        view.layoutIfNeeded()
        pageControl.setNeedsLayout()
        pageControl.layoutIfNeeded()
        
        likeWineListView.snp.makeConstraints {
            $0.top.equalTo(adCollectionView.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview()
        }
        
        popularWineListView.snp.makeConstraints {
            $0.top.equalTo(likeWineListView.snp.bottom).offset(35)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-46)
        }
    }
    
    // MARK: - 컬렉션뷰 업데이트 함수
    func updateCollectionView(type: WineListType, with wines: [WineData]) {
        let maxDisplayCount = 5
        let homeWineModels = toHomeWineModels(Array(wines.prefix(maxDisplayCount)))
        
        if type == .recommended {
            recommendWineDataList = homeWineModels
            likeWineListView.recomCollectionView.reloadData()
        } else if type == .popular {
            popularWineDataList = homeWineModels
            popularWineListView.recomCollectionView.reloadData()
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
    
    func fetchWines(type: WineListType) {
        Task {
            // 1. 캐시 데이터 확인
            let cachedWines = await WineDataManager.shared.fetchWines(type: type)
            if !cachedWines.isEmpty {
                print("✅ 캐시된 \(type.rawValue) 데이터 사용: \(cachedWines.count)개")
                updateCollectionView(type: type, with: cachedWines) // 👉 바로 업데이트
                return
            }
            
            // 2. 네트워크 요청 처리
            await fetchWinesFromNetwork(type: type)
        }
    }

    // MARK: - 네트워크 요청 처리
    private func fetchWinesFromNetwork(type: WineListType) async {
        let fetchFunction: (@escaping (Result<[HomeWineDTO], NetworkError>) -> Void) -> Void

        switch type {
        case .recommended:
            fetchFunction = networkService.fetchRecommendWines
        case .popular:
            fetchFunction = networkService.fetchPopularWines
        }

        await withCheckedContinuation { continuation in
            fetchFunction { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let responseData):
                    Task {
                        await self.processWineData(type: type, responseData: responseData)
                        continuation.resume()
                    }
                case .failure(let error):
                    print("❌ 네트워크 오류 발생: \(error.localizedDescription)")
                    continuation.resume()
                }
            }
        }
    }
    
    private func processWineData(type: WineListType, responseData: [HomeWineDTO]) async {
        let wines = responseData.map {
            WineData(wineId: $0.wineId,
                     imageUrl: $0.imageUrl,
                     wineName: $0.wineName,
                     sort: $0.sort,
                     price: $0.price,
                     vivinoRating: $0.vivinoRating)
        }
        
        do {
            // 1. 기존 데이터 삭제 및 저장
            try await WineDataManager.shared.deleteWineList(type: type)
            try await WineDataManager.shared.saveWines(wines, type: type)
            print("✅ \(type.rawValue) 저장 완료: \(wines.count)개")
            
            updateCollectionView(type: type, with: wines)
        } catch {
            print("❌ 데이터 저장 중 오류 발생: \(error)")
        }
    }
    
    private func updateLikeWineListView() {
        likeWineListView.title.text = "\(userName) 님이 좋아할 만한 와인"
        likeWineListView.title.setPartialTextStyle(
            text: likeWineListView.title.text ?? "",
            targetText: "\(userName)",
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
        pageControl.currentPage = pageIndex
        
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
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didEndDecelerating scrollView: UIScrollView) {
        if collectionView.tag == 0 { // ✅ 광고 컬렉션 뷰만 반응
            let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
            pageControl.currentPage = pageIndex
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return adImage.count
        } else if collectionView.tag == 1 {
            // ✅ Out of range 에러 핸들링
            return min(maxShowWineCount, recommendWineDataList.count)
        } else if collectionView.tag == 2 {
            // ✅ Out of range 에러 핸들링
            return min(maxShowWineCount, popularWineDataList.count)
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdCollectionViewCell.identifier, for: indexPath) as! AdCollectionViewCell
            
            cell.configure(image: adImage[indexPath.item])
            
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
            //let vc = WineDetailViewController
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
