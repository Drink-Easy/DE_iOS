// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import SnapKit
import Then

public class OnboardingVC: UIViewController, UICollectionViewDelegate, FirebaseTrackable {
    public var screenName: String = Tracking.VC.onboardingVC
    
    private var startImage: [String] = ["onboarding1", "onboarding2", "onboarding3"]
    private var titleText: [String] = ["쉽게 배우는 와인 지식", "함께 즐기는 와인", "나만의 테이스팅 노트"]
    private var descriptionText: [String] = ["드링키지, 와인의 진입장벽을 낮추다.", "더 즐거운 시간을 공유해 보세요.", "다양한 테이스팅 노트를 기록하며\n나의 취향에 대해 알아 보세요."]
    
    lazy var pageControl = CustomPageControl(indicatorColor: .white, currentIndicatorColor: AppColor.purple50!).then {
        $0.numberOfPages = startImage.count
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
        
//        if navigationController == nil {
//            let navigationController = UINavigationController(rootViewController: self)
//            navigationController.modalPresentationStyle = .fullScreen
//            
//            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//               let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
//                keyWindow.rootViewController?.present(navigationController, animated: true)
//            }
//        }
        
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = AppColor.bgGray
        setupUI()
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
    }
    
    private func setupUI() {
        view.addSubview(onboardingCollectionView)
        view.addSubview(pageControl)
        view.addSubview(startButton)
        
        onboardingCollectionView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
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
        if pageIndex == startImage.count - 1 {
            let maxOffsetX = CGFloat(startImage.count - 1) * view.frame.width
            if scrollView.contentOffset.x > maxOffsetX {
                scrollView.contentOffset.x = maxOffsetX
            }
        }
    }
}

extension OnboardingVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = 3
        return 3
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as? OnboardingCollectionViewCell else {
            fatalError("Could not dequeue cell with identifier OnboardingCollectionViewCell")
        }
        
        cell.configure(imageName: startImage[indexPath.item], label1: titleText[indexPath.item], label2: descriptionText[indexPath.item])
        return cell
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
