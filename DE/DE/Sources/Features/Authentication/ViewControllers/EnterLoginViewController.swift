//
//  EnterLoginViewController.swift
//  Drink-EG
//
//  Created by 이현주 on 7/30/24.
//

import UIKit

class EnterLoginViewController: UIViewController {
    
    let startButton = UIButton(type: .system)
    
    private var StartImage: [String] = ["start1", "start2", "start3"]
    private var Label1: [String] = ["쉽게 배우는 와인 지식", "함께 즐기는 와인", "나만의 테이스팅 노트"]
    private var Label2: [String] = ["드링키지, 와인의 진입장벽을 낮추다.", "더 즐거운 시간을 공유해보세요!", "다양한 테이스팅 노트를 기록하며\n나의 취향에 대해 알아보세요!"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named:"icon_back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named:"icon_back")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = .white
        
        view.backgroundColor = .black
        setupUI()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
    private func setupUI() {
        configureStartButton()
        
        view.addSubview(StartLoginCollectionView)
        StartLoginCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(pageControl)
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(StartLoginCollectionView.snp.bottom)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        view.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.top.equalTo(pageControl.snp.bottom).offset(32)
//            make.centerX.equalToSuperview()
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(33)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(31)
            make.height.greaterThanOrEqualTo(60)
        }
    }
    
    private func configureStartButton() {
        startButton.setTitle("시작하기", for: .normal)
        startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        startButton.setTitleColor(.white, for: .normal)
        startButton.contentHorizontalAlignment = .center
        
        startButton.backgroundColor = UIColor(hex: "#FF6F62")
        startButton.layer.cornerRadius = 16
        startButton.layer.borderWidth = 0
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    @objc private func startButtonTapped() {
        let selectLoginViewController = SelectLoginViewController()
        navigationController?.pushViewController(selectLoginViewController, animated: true)
    }
    
    lazy var StartLoginCollectionView: UICollectionView = {
        // collection view layout setting
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.footerReferenceSize = .zero
        layout.headerReferenceSize = .zero
                
        // collection view setting
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = true
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.register(StartLoginCollectionViewCell.self, forCellWithReuseIdentifier: "StartLoginCollectionViewCell")
        cv.delegate = self
        cv.dataSource = self
                
        // UI setting
        cv.backgroundColor = .black
                
        return cv
    }()
    
    lazy var pageControl: UIPageControl = {
        let p = UIPageControl()
        p.pageIndicatorTintColor = UIColor(hex: "#767676")
        p.currentPageIndicatorTintColor = UIColor(hex: "#FF6F62")
        return p
    }()

}

extension EnterLoginViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // page control 설정.
        if scrollView.frame.size.width != 0 {
            let value = (scrollView.contentOffset.x / scrollView.frame.width)
            pageControl.currentPage = Int(round(value))
        }
    }
}


extension EnterLoginViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pageControl.numberOfPages = 3
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StartLoginCollectionViewCell", for: indexPath) as! StartLoginCollectionViewCell
        
        cell.configure(imageName: StartImage[indexPath.item], label1: Label1[indexPath.item], label2: Label2[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
