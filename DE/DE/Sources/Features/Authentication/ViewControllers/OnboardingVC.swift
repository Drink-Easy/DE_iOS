// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import SnapKit
import Then
import DesignSystem

public class OnboardingVC: UIViewController, UICollectionViewDelegate, FirebaseTrackable {
    public var screenName: String = Tracking.VC.onboardingVC
    
    lazy var pageControl = CustomPageControl(indicatorColor: .white, currentIndicatorColor: AppColor.purple50).then {
        $0.numberOfPages = OnboardingSlide.allCases.count
        $0.currentPage = 0
    }
    
    private let startButton = CustomBlurButton(
        title: "시작하기",
        titleColor: .white,
        blurStyle: .systemUltraThinMaterial
    ).then {
        $0.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = AppColor.background
        setupUI()
        
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
    
    @objc private func startButtonTapped() {
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.startBtnTapped, fileName: #file)
        
        let selectLoginViewController = SelectLoginTypeVC()
        navigationController?.pushViewController(selectLoginViewController, animated: true)
    }
    
    lazy var onboardingCollectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal // 가로로 스크롤
        layout.minimumLineSpacing = 0 // 셀 간 간격 없음
        layout.minimumInteritemSpacing = 0 // 아이템 간 간격 없음
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true // 페이지 단위 스크롤
        collectionView.showsHorizontalScrollIndicator = false // 가로 스크롤바 숨김
        collectionView.backgroundColor = .clear
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
}

extension OnboardingVC: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let pageIndex = Int(scrollView.contentOffset.x / view.frame.width)
        pageControl.currentPage = pageIndex
        
        if pageIndex == 0 && scrollView.contentOffset.x < 0 {
            scrollView.contentOffset.x = 0
        }
        if pageIndex == OnboardingSlide.allCases.count - 1 {
            let maxOffsetX = CGFloat(OnboardingSlide.allCases.count - 1) * view.frame.width
            if scrollView.contentOffset.x > maxOffsetX {
                scrollView.contentOffset.x = maxOffsetX
            }
        }
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
        
        cell.configure(imageName: slide.imageName, label1: slide.title, label2: slide.description)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
