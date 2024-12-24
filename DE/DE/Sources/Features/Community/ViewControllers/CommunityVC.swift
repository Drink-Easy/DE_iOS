// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import AuthenticationServices
import Moya
import SwiftyToaster
import CoreModule

public class CommunityVC: UIViewController {
    
    // MARK: - UI Components
    private let searchIcon = UIImageView().then {
        $0.image = UIImage(systemName: "magnifyingglass")?.withTintColor(AppColor.gray80 ?? .black, renderingMode: .alwaysOriginal) // 시스템 아이콘과 색상 설정
        $0.contentMode = .scaleAspectFill // 콘텐츠 비율 유지
        $0.clipsToBounds = true // 아이콘 잘림 방지
    }
    
    private let segmentedControl = HomeSegmentControl(items: ["둘러보기", "신청완료", "스크랩"]).then {
        $0.selectedSegmentIndex = 0
        $0.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: AppColor.gray80,
             .font: UIFont.ptdSemiBoldFont(ofSize: 17)],
            for: .normal
        )
        $0.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: AppColor.purple100,
                .font: UIFont.ptdSemiBoldFont(ofSize: 17)
            ],
            for: .selected
        )
        $0.addTarget(self, action: #selector(changeValue), for: .valueChanged)
    }
    
    private lazy var pageViewController: UIPageViewController = {
        let vc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        vc.setViewControllers([self.dataViewControllers[0]], direction: .forward, animated: true)
        vc.delegate = self
        vc.dataSource = nil // 데이터 소스 제거
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        
        // UIPageViewController 스와이프 비활성화
        vc.view.subviews.forEach { subview in
            if let scrollView = subview as? UIScrollView {
                scrollView.isScrollEnabled = false
            }
        }
        return vc
    }()
    
    // MARK: - Data & ViewControllers
    
    private var dataViewControllers: [UIViewController] {
        return [
            ExploreVC(), // 인스턴스를 생성하여 추가
            ScrapVC(),   // 인스턴스를 생성하여 추가
            CompleteVC() // 인스턴스를 생성하여 추가
        ]
    }
    
    private var currentPage: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= currentPage ? .forward : .reverse
            pageViewController.setViewControllers(
                [dataViewControllers[currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
        }
    }
    
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        setupUI()
        setupConstraints()
        segmentedControl.selectedSegmentIndex = 0
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.addSubview(searchIcon)
        view.addSubview(segmentedControl)
        view.addSubview(pageViewController.view)
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
    }
    
    private func setupConstraints() {
        searchIcon.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.size.equalTo(25)
        }
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(Constants.superViewWidth / 1.7)
            make.height.equalTo(48)
        }
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    @objc private func changeValue(control: UISegmentedControl) {
        currentPage = control.selectedSegmentIndex
    }
}

// MARK: - UIPageViewControllerDelegate
extension CommunityVC: UIPageViewControllerDelegate {
    public func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let viewController = pageViewController.viewControllers?.first,
              let index = dataViewControllers.firstIndex(of: viewController) else {
            return
        }
        currentPage = index
        segmentedControl.selectedSegmentIndex = index
    }
}


