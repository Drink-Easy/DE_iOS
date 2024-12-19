////
////  HomeViewController.swift
////  Drink-EG
////
////  Created by 김도연 on 7/20/24.
////
//
//import UIKit
//import SnapKit
//import Moya
//import SDWebImage
//import SafariServices
//import SwiftyToaster
//
//class HomeViewController: UIViewController {
//    
//    let provider = MoyaProvider<SearchAPI>(plugins: [CookiePlugin()])
//    let shoppingListManager = ShoppingListManager.shared
//    
//    private var AdContents: [String] = ["ad1", "ad2", "ad3"]
//    private var AdLinks: [String] = ["https://www.instagram.com/drinkeg.official?igsh=eGoyYzkxNmh5bXR5","https://www.7-eleven.co.kr/event/eventList.asp", "https://github.com/Drink-Easy/moblie-iOS-native"]
//    private var RecomContents: [RecommendWineResponse] = []
//    private var MenuContents: [String] = ["어플 가이드", "콜키지 프리", "위시 리스트", "인기 와인"]
//    var name: String = ""
//    
//    var selectedWine: String?
//    
//    let scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.isDirectionalLockEnabled = true
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        return scrollView
//    }()
//    
//    let contentView: UIView = {
//        let contentView = UIView()
//        contentView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.backgroundColor = .clear
//        return contentView
//    }()
//    
//    private let logoView: UIImageView = {
//        let i = UIImageView()
//        i.image = UIImage(named: "logoSample")
//        return i
//    }()
//    
//    public lazy var searchButton: UIButton = {
//        let b = UIButton()
//        b.setImage(UIImage(named: "icon_search"), for: .normal)
//        return b
//    }()
//    
//    
//    @objc
//    private func goToSearch() {
//        let vc = SearchHomeViewController()
//        navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    let firstLine = UILabel()
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if let navigationController = self.navigationController {
//            navigationController.setNavigationBarHidden(true, animated: false)
//        }
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        
//        view.backgroundColor = .white
//        searchButton.addTarget(self, action: #selector(goToSearch), for: .touchUpInside)
//        getHomeInfo { [weak self] isSuccess in
//            if isSuccess {
//                self?.RecomCollectionView.reloadData()
//                self?.setupUI()
//            } else {
//                print("GET 호출 실패")
//                Toaster.shared.makeToast("503 Service Unavailable", .short)
//            }
//        }
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        if let navigationController = self.navigationController {
//            navigationController.setNavigationBarHidden(false, animated: false)
//        }
//    }
//    
//    private func setupUI() {
//        // label 설정
//        configureLabel()
//
//        view.addSubview(logoView)
//        view.addSubview(searchButton)
//
//        logoView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
//            make.height.greaterThanOrEqualTo(33)
//        }
//        
//        searchButton.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
//            make.centerY.equalTo(logoView)
//        }
//        
//        view.addSubview(scrollView)
//        
//        scrollView.snp.makeConstraints { make in
//            make.top.equalTo(logoView.snp.bottom).offset(15)
//            make.leading.trailing.equalToSuperview()
//            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
//        }
//        
//        scrollView.addSubview(contentView)
//        
//        contentView.snp.makeConstraints { make in
//            make.edges.equalTo(scrollView.contentLayoutGuide)
//            make.height.greaterThanOrEqualTo(scrollView.snp.height).priority(.low)
//            make.width.equalTo(scrollView.frameLayoutGuide)
//        }
//        
//        contentView.addSubview(AdImageCollectionView)
//        contentView.addSubview(pageControl)
//        
//        AdImageCollectionView.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(1)
//            make.centerX.equalToSuperview()
//            make.leading.trailing.equalTo(view)
//            make.height.equalTo(AdImageCollectionView.snp.width).multipliedBy(326.0/390.0)
//        }
//        
//        pageControl.snp.makeConstraints { make in
//            make.top.equalTo(AdImageCollectionView.snp.bottom).offset(-27)
//            make.centerX.equalTo(view.safeAreaLayoutGuide)
//        }
//        
//        contentView.addSubview(MenuCollectionView)
//        
//        MenuCollectionView.snp.makeConstraints { make in
//            make.top.equalTo(AdImageCollectionView.snp.bottom).offset(34)
//            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(32.5)
//            make.height.greaterThanOrEqualTo(70)
//        }
//        
//        contentView.addSubview(firstLine)
//        
//        firstLine.snp.makeConstraints {make in      
//            make.top.equalTo(MenuCollectionView.snp.bottom).offset(33)
//            make.leading.equalTo(view.safeAreaLayoutGuide).offset(21)
//        }
//        
//        contentView.addSubview(RecomCollectionView)
//        
//        RecomCollectionView.snp.makeConstraints { make in
//            make.top.equalTo(firstLine.snp.bottom).offset(8)
//            make.centerX.equalTo(view.safeAreaLayoutGuide)
//            make.leading.trailing.equalTo(firstLine).offset(-5)
//            make.height.greaterThanOrEqualTo(166)
//            make.bottom.equalToSuperview().inset(20)
//        }
//        
//        contentView.snp.makeConstraints { make in
//            make.bottom.equalToSuperview().inset(20)
//        }
//    }
//
//    private func configureLabel() {
//        firstLine.text = "\(name) 님이 좋아할 만한 와인"
//        firstLine.font = UIFont.systemFont(ofSize: 24, weight: .bold)
//        
//        guard let text = self.firstLine.text else { return }
//        let attributedStr = NSMutableAttributedString(string: text)
//        attributedStr.addAttribute(.foregroundColor, value: UIColor(hex: "7E13B1") ?? .black, range: (text as NSString).range(of: "\(name)"))
//        self.firstLine.attributedText = attributedStr
//    }
//    
//    lazy var AdImageCollectionView: UICollectionView = {
//        // collection view layout setting
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 0
//        layout.minimumInteritemSpacing = 0
//        layout.footerReferenceSize = .zero
//        layout.headerReferenceSize = .zero
//        
//        // collection view setting
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.isScrollEnabled = true
//        cv.isPagingEnabled = true
//        cv.showsHorizontalScrollIndicator = false
//        cv.register(AdImageCollectionViewCell.self, forCellWithReuseIdentifier: "AdImageCollectionViewCell")
//        cv.delegate = self
//        cv.dataSource = self
//        cv.tag = 1
//        
//        // UI setting
//        cv.backgroundColor = .clear
//        cv.layer.shadowOpacity = 0.3
//        cv.layer.shadowColor = UIColor.black.cgColor
//        cv.layer.shadowOffset = CGSize(width: 0, height: 2)
//        cv.layer.shadowRadius = 5
//        cv.layer.masksToBounds = false
//        
//        return cv
//    }()
//    
//    lazy var pageControl: UIPageControl = {
//        let p = UIPageControl()
//        p.pageIndicatorTintColor = UIColor(hex: "#D9D9D9")
//        p.currentPageIndicatorTintColor = UIColor(hex: "#5813B1")
//        return p
//    }()
//    
//    lazy var RecomCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 10 // 셀 사이의 간격
//        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // 컬렉션뷰의 양 끝에 패딩 추가
//        
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.register(RecomCollectionViewCell.self, forCellWithReuseIdentifier: "RecomCollectionViewCell")
//        cv.translatesAutoresizingMaskIntoConstraints = false
//        cv.showsHorizontalScrollIndicator = false
//        cv.delegate = self
//        cv.dataSource = self
//        cv.tag = 2
//        
//        cv.decelerationRate = .fast
//        cv.backgroundColor = .clear
//        
//        return cv
//    }()
//    
//    lazy var MenuCollectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 16 // 셀 사이의 간격
//        
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.register(MenuCollectionViewCell.self, forCellWithReuseIdentifier: "MenuCollectionViewCell")
//        cv.translatesAutoresizingMaskIntoConstraints = false
//        cv.showsHorizontalScrollIndicator = false
//        cv.delegate = self
//        cv.dataSource = self
//        cv.tag = 3
//        
//        cv.decelerationRate = .fast
//        cv.backgroundColor = .clear
//        cv.layer.cornerRadius = 5
//        
//        return cv
//    }()
//}
//
//extension HomeViewController: UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        // page control 설정.
//        if scrollView.frame.size.width != 0 {
//            let value = (scrollView.contentOffset.x / scrollView.frame.width)
//            pageControl.currentPage = Int(round(value))
//        }
//    }
//}
//
//extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if collectionView.tag == 1 {
//            pageControl.numberOfPages = AdContents.count
//            return self.AdContents.count
//        }
//        else if collectionView.tag == 2 {
//            return self.RecomContents.count
//        }
//        else if collectionView.tag == 3 {
//            return 4
//        }
//        return 0
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if collectionView.tag == 1 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdImageCollectionViewCell", for: indexPath) as! AdImageCollectionViewCell
//            
//            cell.configure(image: AdContents[indexPath.item])
//            return cell
//        }
//        else if collectionView.tag == 2 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecomCollectionViewCell", for: indexPath) as! RecomCollectionViewCell
//            
//            let recom = RecomContents[indexPath.row]
//            cell.configure(recom: recom)
//            return cell
//            
//        }
//        else if collectionView.tag == 3 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCell", for: indexPath) as! MenuCollectionViewCell
//            
//            cell.configure(name: MenuContents[indexPath.item])
//            return cell
//        }
//        return UICollectionViewCell()
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView.tag == 1 {
//            let adURL = NSURL(string: AdLinks[indexPath.row])
//            let adSafariView: SFSafariViewController = SFSafariViewController(url: adURL! as URL)
//            self.present(adSafariView, animated: true, completion: nil)
//        }
//        else if collectionView.tag == 2 {
//            let selectedWine = RecomContents[indexPath.row]
//            let wineInfoViewController = WineInfoViewController()
//            wineInfoViewController.name.text = selectedWine.wineName
//            wineInfoViewController.wineImageURL = selectedWine.imageUrl
//            wineInfoViewController.wineId = selectedWine.wineId
//            navigationController?.pushViewController(wineInfoViewController, animated: true)
//        }
//        else if collectionView.tag == 3 {
//            //메뉴 셀마다 클릭 시 해당 페이지로 이동
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if collectionView.tag == 1 {
//            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
//        }
//        else if collectionView.tag == 2 {
//            return CGSize(width: ((collectionView.frame.height)*0.9), height: ((collectionView.frame.height)*0.9))
//        }
//        else if collectionView.tag == 3 {
//            return CGSize(width: collectionView.frame.height, height: collectionView.frame.height)
//        }
//        return CGSize.zero
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        if collectionView.tag == 3 {
//            // 컬렉션 뷰에서 셀을 가운데에 정렬하기 위해 좌우 여백을 계산
//            let totalCellWidth = 100 * CGFloat(collectionView.numberOfItems(inSection: section)) // 셀 크기 * 셀 개수
//            let totalSpacingWidth = 10 * CGFloat(collectionView.numberOfItems(inSection: section) - 1) // 셀 사이 간격 * 간격 개수
//            
//            let totalContentWidth = totalCellWidth + totalSpacingWidth
//            let collectionViewWidth = collectionView.bounds.width
//            
//            // 가운데 정렬을 위해 남는 공간을 양쪽 여백으로 나누어 설정
//            let inset = max((collectionViewWidth - totalContentWidth) / 2.0, 0)
//            
//            return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
//        }
//        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//    }
//    
//    func getHomeInfo(completion: @escaping (Bool) -> Void) {
//        provider.request(.getHomeInfo) { result in
//            switch result {
//            case .success(let response):
//                do {
//                    if let jsonString = String(data: response.data, encoding: .utf8) {
////                        print("Received JSON: \(jsonString)")
//                    }
//                    let responseData = try JSONDecoder().decode(APIResponseHomeResponse.self, from: response.data)
//                    self.name = responseData.result.name
//                    SelectionManager.shared.userName = responseData.result.name
//                    self.RecomContents = responseData.result.recommendWineDTOs
//                    self.RecomCollectionView.reloadData()
//                    completion(true)
//                } catch {
//                    print("Failed to decode response: \(error)")
//                    completion(false)
//                }
//            case.failure(let error):
//                print("Error: \(error.localizedDescription)")
//                if let response = error.response {
//                    print("Response Body: \(String(data: response.data, encoding: .utf8) ?? "")")
//                }
//                completion(false)
//            }
//        }
//    }
//}
//
//
//
