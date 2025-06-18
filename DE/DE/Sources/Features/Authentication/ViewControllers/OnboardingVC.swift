// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import SnapKit
import Then
import DesignSystem
import Network

public class OnboardingVC: UIViewController, UICollectionViewDelegate, FirebaseTrackable {
    public var screenName: String = Tracking.VC.onboardingVC
    
    var pageControl = CustomPageControl(indicatorColor: AppColor.gray50, currentIndicatorColor: AppColor.purple50)
    
    private let startButton = CustomButton(title: "다음으로").then {
        $0.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = AppColor.background
        setupUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageControl.numberOfPages = OnboardingSlide.allCases.count
        pageControl.currentPage = 0
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
    }
    
    private func setupUI() {
        view.addSubviews(onboardingCollectionView, pageControl, startButton)
        
        onboardingCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(startButton.snp.top).inset(-DynamicPadding.dynamicValue(32.0))
            make.width.equalTo(100) // 페이지 컨트롤 너비 설정
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(DynamicPadding.dynamicValue(32.0))
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(DynamicPadding.dynamicValue(32.0) * 2)
            make.height.equalTo(60)
        }
        
        view.layoutIfNeeded()
        pageControl.setNeedsLayout()
        pageControl.layoutIfNeeded()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pageControl.setNeedsLayout()
        pageControl.layoutIfNeeded()
    }
    
    @objc private func startButtonTapped() {
        let currentPage = pageControl.currentPage
        let isLast = currentPage == OnboardingSlide.allCases.count - 1
        print("스크롤 디버깅: 마지막인가요? \(isLast)")
        
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.startBtnTapped, fileName: #file)
        
        if isLast {
            // 코디네이터로 나중에 이동
            let viewModel = SelectLoginViewModel(
                kakaoAuthVM: KakaoAuthVM(),
                networkService: AuthService()
            )
            let selectLoginViewController = SelectLoginTypeVC(viewModel: viewModel)
            
            navigationController?.pushViewController(selectLoginViewController, animated: true)
        } else {
            let nextIndex = currentPage + 1
            let indexPath = IndexPath(item: nextIndex, section: 0)
            print("스크롤 디버깅: \(indexPath.item)번 슬라이드")
            onboardingCollectionView.isPagingEnabled = false
            onboardingCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            
//            pageControl.currentPage = nextIndex
//            updateStartButtonTitle(for: nextIndex)
            onboardingCollectionView.isPagingEnabled = true
        }
    }
    
    private func updateStartButtonTitle(for index: Int) {
        let isLast = index == OnboardingSlide.allCases.count - 1
        let title = isLast ? "시작하기" : "다음으로"
        startButton.configure(title: title, titleColor: .white, isEnabled: true)
    }
    
    lazy var onboardingCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // 가로로 스크롤
        layout.minimumLineSpacing = 0 // 셀 간 간격 없음
        layout.minimumInteritemSpacing = 0 // 아이템 간 간격 없음
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false // 가로 스크롤바 숨김
        collectionView.backgroundColor = .clear
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
}

extension OnboardingVC: UIScrollViewDelegate {
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
        
        if pageIndex == 0 && scrollView.contentOffset.x < 0 {
            scrollView.contentOffset.x = 0
        }
        if pageIndex == OnboardingSlide.allCases.count - 1 {
            let maxOffsetX = CGFloat(OnboardingSlide.allCases.count - 1) * view.frame.width
            if scrollView.contentOffset.x > maxOffsetX {
                scrollView.contentOffset.x = maxOffsetX
            }
        }
        
        pageControl.currentPage = pageIndex
        updateStartButtonTitle(for: pageIndex)
        print("스크롤 디버깅 : \(pageIndex)")
    }
}

extension OnboardingVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = OnboardingSlide.allCases.count
        return OnboardingSlide.allCases.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as? OnboardingCollectionViewCell else {
            fatalError("Could not dequeue cell with identifier OnboardingCollectionViewCell")
        }
        
        let slide = OnboardingSlide.allCases[indexPath.item]
        cell.configure(imageName: slide.imageName, titleText: slide.title, despText: slide.description)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
