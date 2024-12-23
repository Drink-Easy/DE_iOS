// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import SnapKit
import Then

public class OnboardingVC: UIViewController, UICollectionViewDelegate {
    
    private var StartImage: [String] = ["onboarding1", "onboarding2", "onboarding3"]
    private var Label1: [String] = ["쉽게 배우는 와인 지식", "함께 즐기는 와인", "나만의 테이스팅 노트"]
    private var Label2: [String] = ["드링키지, 와인의 진입장벽을 낮추다.", "더 즐거운 시간을 공유해 보세요.", "다양한 테이스팅 노트를 기록하며\n나의 취향에 대해 알아 보세요."]
    
    lazy var pageControl: CustomPageControl = {
        let pc = CustomPageControl()
        pc.numberOfPages = StartImage.count
        pc.currentPage = 0
        return pc
    }()
    
    private let startButton = CustomBlurButton(
        title: "시작하기",
        titleColor: .white,
        blurStyle: .light
    ).then {
        $0.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
//    private let startButton = CustomButton(
//        title: "로그인",
//        titleColor: .white,
//        backgroundColor: AppColor.purple100!
//    ).then {
//        $0.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
//    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named:"icon_back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named:"icon_back")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = .white
        
        view.backgroundColor = AppColor.bgGray
        setupUI()
        
    }
    
    private func setupUI() {
        view.addSubview(OnboardingCollectionView)
        view.addSubview(pageControl)
        view.addSubview(startButton)
        
        OnboardingCollectionView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(120)
            make.width.equalTo(100) // 페이지 컨트롤 너비 설정
        }
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Constants.padding)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(Constants.padding)
            make.height.equalTo(60)
        }
        view.layoutIfNeeded()
        pageControl.setNeedsLayout()
        pageControl.layoutIfNeeded()
    }
    
    @objc private func startButtonTapped() {
        let selectLoginViewController = SelectLoginTypeVC()
        navigationController?.pushViewController(selectLoginViewController, animated: true)
    }
    
    lazy var OnboardingCollectionView: UICollectionView = {
        
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
        if pageIndex == StartImage.count - 1 {
            let maxOffsetX = CGFloat(StartImage.count - 1) * view.frame.width
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        
        cell.configure(imageName: StartImage[indexPath.item], label1: Label1[indexPath.item], label2: Label2[indexPath.item])
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
