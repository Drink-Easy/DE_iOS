// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import CoreModule
import SwiftyToaster

class NewbieFoodViewController: UIViewController {
    
    private let navigationBarManager = NavigationBarManager()
    
    let cellData = ["육류 (스테이크, 바비큐, 치킨 등)", "해산물 (회, 새우, 랍스터 등)", "치즈", "스낵 (견과류, 올리브, 프로슈토 등)", "피자, 파스타", "디저트"]
    
    private var selectedItems: [String] = []
    private let maxSelectionCount = 2

    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        self.view = surveyFoodView
        setupNavigationBar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private lazy var surveyFoodView = SurveyFoodView(titleText: "평소 즐겨먹는\n안주를 골라주세요(2개 선택)", currentPage: 2, entirePage: 3, buttonTitle: "다음").then {
        $0.surveyFoodCollectionView.delegate = self
        $0.surveyFoodCollectionView.dataSource = self
        
        $0.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc func nextButtonTapped() {
        let vc = NewbieConsumeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension NewbieFoodViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SurveyFoodCollectionViewCell.identifier, for: indexPath) as! SurveyFoodCollectionViewCell
        
        let title = cellData[indexPath.row]
        cell.configure(contents: title)
        
        cell.isSelected = selectedItems.contains(title)
        cell.updateAppearance(isSelected: cell.isSelected)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = cellData[indexPath.row]
        
        if selectedItems.contains(selectedItem) { //이미 selected된 cell
            selectedItems.removeAll { $0 == selectedItem }
        } else {
            if selectedItems.count >= maxSelectionCount { // 이미 2개 선택
                Toaster.shared.makeToast("선택할 수 있는 갯수를 초과했습니다.", .short)
                return
            }
            // 새 아이템 선택
            selectedItems.append(selectedItem)
        }
        
        // UI 업데이트
        collectionView.reloadData()
        surveyFoodView.nextButton.isEnabled = selectedItems.count >= 1
        surveyFoodView.nextButton.isEnabled(isEnabled: selectedItems.count >= 1)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: DynamicPadding.dynamicValue(81.0))
    }
}

