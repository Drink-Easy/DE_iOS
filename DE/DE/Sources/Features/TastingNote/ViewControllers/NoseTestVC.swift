// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

// 향 선택 뷰컨

public class NoseTestVC: UIViewController {
    let chooseNoseView = NoseTopView()
    let navigationBarManager = NavigationBarManager()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        setupUI()
//        setupCollectionView()
        setupNavigationBar()
        
    }
    
    private func setupUI() {
        chooseNoseView.header.setTitleLabel("아무와인이나넣어")
        
        view.addSubview(chooseNoseView)
        chooseNoseView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().offset(24)
        }
    }
    
    private func setupCollectionView() {
//        // 레이아웃 설정
//        let noseCollectionView = chooseNoseView.collectionView // ChooseNoseView의 컬렉션 뷰 사용
//        noseCollectionView.delegate = self
//        noseCollectionView.dataSource = self
//        
//        // 셀 및 헤더 등록
//        noseCollectionView.register(NoseCollectionViewCell.self, forCellWithReuseIdentifier: NoseCollectionViewCell.identifier)
//        noseCollectionView.register(NoseCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        
//        let selectedCollectionView = chooseNoseView.selectedCollectionView
//        selectedCollectionView.delegate = self
//        selectedCollectionView.dataSource = self
//        
//        selectedCollectionView.register(NoseCollectionViewCell.self, forCellWithReuseIdentifier: NoseCollectionViewCell.identifier)
    }
    
//    func setupActions() {
//        chooseNoseView.nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
//    }
    
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC)
        )
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
        let nextVC = RecordGraphViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
