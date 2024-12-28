// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Then
//import Authentication
import Network
import SearchModule

public class HomeViewController: UIViewController, HomeTopViewDelegate {
    
    private var adImage: [String] = ["ad4", "ad3", "ad2", "ad1"]
    var wineData: [HomeWineModel] = []
    public var userName: String = "" {
        didSet {
            updateLikeWineListView()
        }
    }
    
    private var homeTopView = HomeTopView()
    
    let networkService = WineService()
    
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
    
//    private lazy var pageControl = CustomPageControl().then {
//        $0.numberOfPages = adImage.count
//        $0.currentPage = 0
//        $0.indicatorColor = UIColor(hex: "#D9D9D9") ?? .lightGray
//        $0.currentIndicatorColor = AppColor.purple100 ?? .purple
//    }
    
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
        
        callHomeAPI()
    }
    
    private func addComponents() {
        [homeTopView, scrollView].forEach{ view.addSubview($0) }
        scrollView.addSubview(contentView)
        [adCollectionView, likeWineListView, popularWineListView].forEach{ contentView.addSubview($0) }
        
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
        
//        pageControl.snp.makeConstraints {
//            $0.centerX.equalTo(view.safeAreaLayoutGuide)
//            $0.bottom.equalTo(adCollectionView.snp.bottom).inset(20)
//        }
        
//        view.layoutIfNeeded()
//        pageControl.setNeedsLayout()
//        pageControl.layoutIfNeeded()
        
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
    
    func callHomeAPI() {
        networkService.fetchRecommendWines { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let responseData) :
                DispatchQueue.main.async {
                    self.wineData = []
                    for data in responseData {
                        let wine = HomeWineModel(wineId: data.wineId, wineName: data.wineName, imageURL: data.imageUrl)
                        self.wineData.append(wine)
                    }
                    self.likeWineListView.recomCollectionView.reloadData()
                }
            case .failure(let error) :
                print("\(error)")
            }
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

//extension HomeViewController: UIScrollViewDelegate {
//    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        
//        let pageIndex = Int(scrollView.contentOffset.x / view.frame.width)
//        pageControl.currentPage = pageIndex
//        
//        if pageIndex == 0 && scrollView.contentOffset.x < 0 {
//                scrollView.contentOffset.x = 0
//            }
//        if pageIndex == adImage.count - 1 {
//            let maxOffsetX = CGFloat(adImage.count - 1) * view.frame.width
//            if scrollView.contentOffset.x > maxOffsetX {
//                scrollView.contentOffset.x = maxOffsetX
//            }
//        }
//    }
//}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return adImage.count
        } else if collectionView.tag == 1 {
            return wineData.count
        }else if collectionView.tag == 2 {
            return 5
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
            
            let wine = wineData[indexPath.row]
            
            cell.configure(imageURL: wine.imageURL, score: "0.0", price: "무료", name: wine.wineName, kind: "모룸")
            
            return cell
            
        } else if collectionView.tag == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecomCollectionViewCell.identifier, for: indexPath) as! RecomCollectionViewCell
            
            return cell

        }
        return UICollectionViewCell()
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
