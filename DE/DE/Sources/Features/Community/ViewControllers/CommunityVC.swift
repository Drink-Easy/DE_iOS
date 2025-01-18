//// Copyright © 2024 DRINKIG. All rights reserved
//
//import UIKit
//
//import SnapKit
//import Then
//
//import SwiftyToaster
//import CoreModule
//
//public class CommunityVC: UIViewController {
//    
//    // MARK: - UI Components
//    private let searchIcon = UIImageView().then {
//        $0.image = UIImage(systemName: "magnifyingglass")?.withTintColor(AppColor.gray80 ?? .black, renderingMode: .alwaysOriginal)
//        $0.contentMode = .scaleAspectFill
//        $0.clipsToBounds = true
//    }
//    
//    private let segmentedControl = HomeSegmentControl(items: ["둘러보기", "신청완료", "스크랩"]).then {
//        $0.selectedSegmentIndex = 0
//        $0.setTitleTextAttributes(
//            [NSAttributedString.Key.foregroundColor: AppColor.gray80,
//             .font: UIFont.ptdSemiBoldFont(ofSize: 17)],
//            for: .normal
//        )
//        $0.setTitleTextAttributes(
//            [
//                NSAttributedString.Key.foregroundColor: AppColor.purple100,
//                .font: UIFont.ptdSemiBoldFont(ofSize: 17)
//            ],
//            for: .selected
//        )
//        $0.addTarget(self, action: #selector(changeValue), for: .valueChanged)
//    }
//    
//    private lazy var pageViewController: UIPageViewController = {
//        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
//        vc.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
//        vc.delegate = self
//        vc.dataSource = nil // 데이터 소스 비활성화
//        vc.view.translatesAutoresizingMaskIntoConstraints = false
//
//        // UIPageViewController 스와이프 비활성화
//        vc.view.subviews.forEach { subview in
//            if let scrollView = subview as? UIScrollView {
//                scrollView.isScrollEnabled = false
//            }
//        }
//        return vc
//    }()
//    
//    private let floatingButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setImage(UIImage(named: "pencil"), for: .normal)
//        button.tintColor = .white
//        button.backgroundColor = AppColor.purple100
//        button.layer.cornerRadius = 25
//        
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowOpacity = 0.1
//        button.layer.shadowOffset = CGSize(width: 0, height: 4)
//        button.layer.shadowRadius = 8
//        button.layer.masksToBounds = false
//        return button
//    }()
//    
//    // MARK: - Data & ViewControllers
//    private var dataView: [UIView] {
//        return [
//            ExploreView(),
//            ExploreView(),
//            ExploreView()
////            ScrapView(),
////            CompletedView()
//        ]
//    }
//    
//    private var dataViewControllers: [UIViewController] {
//        return dataView.map { WrapperViewController(wrappedView: $0) }
//    }
//    
//    private var currentPage: Int = 0 {
//        didSet {
//            let direction: UIPageViewController.NavigationDirection = oldValue <= currentPage ? .forward : .reverse
//            pageViewController.setViewControllers(
//                [dataViewControllers[currentPage]],
//                direction: direction,
//                animated: true,
//                completion: nil
//            )
//        }
//    }
//    
//    // MARK: - Life Cycle
//    public override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = AppColor.bgGray
//        self.navigationController?.navigationBar.isHidden = true
//        setupUI()
//        setupConstraints()
//        segmentedControl.selectedSegmentIndex = 0
//    }
//    
//    // MARK: - Setup Methods
//    private func setupUI() {
//        view.addSubview(searchIcon)
//        view.addSubview(segmentedControl)
//        
//        view.addSubview(pageViewController.view)
//        view.addSubview(floatingButton)
//        addChild(pageViewController)
//        pageViewController.didMove(toParent: self)
//    }
//    
//    private func setupConstraints() {
//        searchIcon.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide)
//            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
//            make.size.equalTo(25)
//        }
//        segmentedControl.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
//            make.leading.equalToSuperview().inset(16)
//            make.width.equalTo(Constants.superViewWidth / 1.7)
//            make.height.equalTo(48)
//        }
//        pageViewController.view.snp.makeConstraints { make in
//            make.top.equalTo(segmentedControl.snp.bottom).offset(8)
//            make.leading.trailing.bottom.equalToSuperview()
//        }
//        floatingButton.snp.makeConstraints { make in
//            make.width.height.equalTo(50)
//            make.trailing.equalToSuperview().inset(16)
//            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
//        }
//    }
//    
//    // MARK: - Actions
//    @objc private func changeValue(control: UISegmentedControl) {
//        currentPage = control.selectedSegmentIndex
//    }
//}
//
//// MARK: - WrapperViewController
//class WrapperViewController: UIViewController {
//    private let wrappedView: UIView
//    
//    init(wrappedView: UIView) {
//        self.wrappedView = wrappedView
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(wrappedView)
//        wrappedView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            wrappedView.topAnchor.constraint(equalTo: view.topAnchor),
//            wrappedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            wrappedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            wrappedView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//}
//
//// MARK: - UIPageViewControllerDelegate
//extension CommunityVC: UIPageViewControllerDelegate {
//    public func pageViewController(
//        _ pageViewController: UIPageViewController,
//        didFinishAnimating finished: Bool,
//        previousViewControllers: [UIViewController],
//        transitionCompleted completed: Bool
//    ) {
//        guard let viewController = pageViewController.viewControllers?.first,
//              let index = dataViewControllers.firstIndex(of: viewController) else {
//            return
//        }
//        currentPage = index
//        segmentedControl.selectedSegmentIndex = index
//    }
//}
