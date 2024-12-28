//
//  ChooseTypeViewController.swift
//  Drink-EG
//
//  Created by 이수현 on 12/17/24.
//

import UIKit
import CoreModule

public class ChooseNoseViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    var sections: [NoseSectionModel] = NoseSectionModel.sections() // 섹션 데이터
    var selectedItems: [String: [NoseModel]] = [:]
    
    let chooseNoseView = ChooseNoseView()
    let navigationBarManager = NavigationBarManager()

    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.gray20
        setupUI()
        setupCollectionView() // CollectionView 설정
        setupActions()
        setupNavigationBar()
    }
    
    private func setupUI() {
        view.addSubview(chooseNoseView)
        chooseNoseView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        // 레이아웃 설정
        let noseCollectionView = chooseNoseView.collectionView // ChooseNoseView의 컬렉션 뷰 사용
        noseCollectionView.delegate = self
        noseCollectionView.dataSource = self
        
        // 셀 및 헤더 등록
        noseCollectionView.register(NoseCollectionViewCell.self, forCellWithReuseIdentifier: NoseCollectionViewCell.identifier)
        noseCollectionView.register(NoseCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        
        let selectedCollectionView = chooseNoseView.selectedCollectionView
        selectedCollectionView.delegate = self
        selectedCollectionView.dataSource = self
        
        selectedCollectionView.register(NoseCollectionViewCell.self, forCellWithReuseIdentifier: NoseCollectionViewCell.identifier)
        // selectedCollectionView.register(NoseCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
    }
    
    func setupActions() {
        chooseNoseView.nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: AppColor.gray80!
        )
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(selectedItems)
            UserDefaults.standard.set(data, forKey: "nose")
            print("\(selectedItems)")
        } catch {
            print("\(error)")
        }
        
        let nextVC = RecordGraphViewController()
        nextVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
