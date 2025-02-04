// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import CoreModule
import SwiftyToaster

class ManiaKindViewController: UIViewController {

    private let navigationBarManager = NavigationBarManager()
    
    let cellData = [DrinkSort.레드.rawValue, DrinkSort.화이트.rawValue, DrinkSort.스파클링.rawValue, DrinkSort.로제.rawValue, DrinkSort.주정강화.rawValue, DrinkSort.내추럴.rawValue]
    
    private var selectedItems: [String] = []
    private let maxSelectionCount = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        self.view = surveyKindView
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
    
    private lazy var surveyKindView = SurveyKindView(titleText: "선호하는 와인 종류를\n골라주세요", currentPage: 2, entirePage: 4, buttonTitle: "다음").then {
        $0.surveyKindCollectionView.delegate = self
        $0.surveyKindCollectionView.dataSource = self
        
        $0.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc func nextButtonTapped() {
        UserSurveyManager.shared.setSort(selectedItems)
        let vc = ManiaTypeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension ManiaKindViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SurveyKindCollectionViewCell.identifier, for: indexPath) as! SurveyKindCollectionViewCell
        
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
//            if selectedItems.count >= maxSelectionCount { // 이미 2개 선택
//                Toaster.shared.makeToast("선택할 수 있는 갯수를 초과했습니다.", .short)
//                return
//            }
            // 새 아이템 선택
            selectedItems.append(selectedItem)
        }
        
        // UI 업데이트
        collectionView.reloadData()
        surveyKindView.nextButton.isEnabled = selectedItems.count >= 1
        surveyKindView.nextButton.isEnabled(isEnabled: selectedItems.count >= 1)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let title = cellData[indexPath.row]
        let font = UIFont.ptdMediumFont(ofSize: 16)
        let size = title.size(withAttributes: [.font: font])
        
        let padding: CGFloat = DynamicPadding.dynamicValue(40.0)
        let cellWidth = size.width + padding
        
        return CGSize(width: cellWidth, height: DynamicPadding.dynamicValue(49.0))
    }
}
