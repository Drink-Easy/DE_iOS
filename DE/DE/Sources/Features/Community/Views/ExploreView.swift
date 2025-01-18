//// Copyright © 2024 DRINKIG. All rights reserved
//
//import UIKit
//
//import SnapKit
//import Then
//
//import CoreModule
//
//class ExploreView: UIView {
//    
//    // MARK: - UI Components
//    private let titleLabel = UILabel().then {
//        $0.text = "마감 임박 모임" // 텍스트 설정
//        $0.textColor = .black // 텍스트 색상
//        $0.font = UIFont.systemFont(ofSize: 18, weight: .bold) // 폰트 설정
//        $0.textAlignment = .left // 텍스트 정렬
//        $0.numberOfLines = 1 // 한 줄로 제한
//    }
//    
//    private let topCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal // 가로 스크롤
//        layout.itemSize = CGSize(width: Constants.superViewWidth - 64, height: 120)
//        layout.minimumLineSpacing = 64
//        layout.sectionInset = UIEdgeInsets(top: 16, left: 32, bottom: 16, right: 32)
//        
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .clear
//        collectionView.isPagingEnabled = true // 페이징 활성화
//        collectionView.showsHorizontalScrollIndicator = false // 가로 스크롤바 숨김
//        return collectionView
//    }()
//    
//    private let pageControl: UIPageControl = {
//        let pageControl = UIPageControl()
//        pageControl.currentPage = 0
//        pageControl.pageIndicatorTintColor = .lightGray
//        pageControl.currentPageIndicatorTintColor = AppColor.purple100
//        return pageControl
//    }()
//    
//    private let bottomCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal // 가로 스크롤
//        layout.itemSize = CGSize(width: 340, height: 120)
//        layout.minimumLineSpacing = 16
//        layout.sectionInset = UIEdgeInsets(top: 16, left: 32, bottom: 16, right: 16)
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.backgroundColor = .clear
//        collectionView.isPagingEnabled = true // 페이징 활성화
//        collectionView.showsHorizontalScrollIndicator = false // 가로 스크롤바 숨김
//        return collectionView
//    }()
//    
//    // 데이터 배열
//    private var topData: [CommunityItem] = []
//    private var bottomData: [CommunityItem] = []
//    
//    // MARK: - Initializer
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//        setupConstraints()
//        setupCollectionView()
//        fetchData()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupUI()
//        setupConstraints()
//        setupCollectionView()
//        fetchData()
//    }
//    
//    // MARK: - Setup Methods
//    
//    private func setupUI() {
//        addSubview(topCollectionView)
//        addSubview(pageControl)
//        addSubview(bottomCollectionView)
//    }
//    
//    private func setupConstraints() {
//        topCollectionView.snp.makeConstraints { make in
//            make.top.equalTo(safeAreaLayoutGuide).offset(16)
//            make.leading.trailing.equalToSuperview()
//            make.height.equalTo(120 + 32) // 한 줄 높이
//        }
//        
//        pageControl.snp.makeConstraints { make in
//            make.top.equalTo(topCollectionView.snp.bottom).offset(-8)
//            make.centerX.equalToSuperview()
//        }
//        
//        bottomCollectionView.snp.makeConstraints { make in
//            make.top.equalTo(pageControl.snp.bottom).offset(16)
//            make.leading.trailing.bottom.equalToSuperview()
//        }
//    }
//    
//    private func setupCollectionView() {
//        topCollectionView.dataSource = self
//        topCollectionView.delegate = self
//        topCollectionView.register(CommunityCell.self, forCellWithReuseIdentifier: CommunityCell.reuseIdentifier)
//        
//        bottomCollectionView.dataSource = self
//        bottomCollectionView.delegate = self
//        bottomCollectionView.register(CommunityCell.self, forCellWithReuseIdentifier: CommunityCell.reuseIdentifier)
//    }
//    
//    private func fetchData() {
//        // 예시 데이터
//        topData = (1...5).map { _ in
//            CommunityItem(
//                mediaURL: "https://via.placeholder.com/150",
//                title: "퇴근 후 다이닝",
//                memberCount: "4",
//                price: "40,000",
//                location: "서울시 강남구",
//                createdAt: "2024.7.3 19시",
//                bookmarked: false
//            )
//        }
//        
//        bottomData = (1...10).map { _ in
//            CommunityItem(
//                mediaURL: "https://via.placeholder.com/150",
//                title: "방금 생겼어요",
//                memberCount: "2",
//                price: "20,000",
//                location: "서울시 송파구",
//                createdAt: "2024.7.5 11시",
//                bookmarked: true
//            )
//        }
//        
//        pageControl.numberOfPages = topData.count // 페이지 수 설정
//        topCollectionView.reloadData()
//        bottomCollectionView.reloadData()
//    }
//}
//
//// MARK: - UICollectionViewDataSource
//
//extension ExploreView: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView == topCollectionView {
//            return topData.count
//        } else if collectionView == bottomCollectionView {
//            return bottomData.count
//        }
//        return 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: CommunityCell.reuseIdentifier,
//            for: indexPath
//        ) as? CommunityCell else {
//            return UICollectionViewCell()
//        }
//        
//        let item: CommunityItem
//        if collectionView == topCollectionView {
//            item = topData[indexPath.item]
//        } else {
//            item = bottomData[indexPath.item]
//        }
//        
//        cell.configure(
//            mediaURL: item.mediaURL,
//            title: item.title,
//            memberCount: item.memberCount,
//            price: item.price,
//            location: item.location,
//            createdAt: item.createdAt,
//            bookmarked: item.bookmarked
//        )
//        return cell
//    }
//}
//
//// MARK: - UICollectionViewDelegate
//
//extension ExploreView: UICollectionViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        // 스크롤 위치에 따라 페이지 컨트롤 업데이트
//        if scrollView == topCollectionView {
//            let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
//            pageControl.currentPage = pageIndex
//        }
//    }
//}
//
//// MARK: - Data Model
//
//struct CommunityItem {
//    let mediaURL: String
//    let title: String
//    let memberCount: String
//    let price: String
//    let location: String
//    let createdAt: String
//    let bookmarked: Bool
//}
