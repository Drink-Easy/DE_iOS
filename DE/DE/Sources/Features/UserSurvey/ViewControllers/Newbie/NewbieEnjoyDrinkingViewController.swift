// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import CoreModule
import DesignSystem
import SwiftyToaster

public class NewbieEnjoyDrinkingViewController: UIViewController, FirebaseTrackable {
    public var screenName: String = Tracking.VC.NewbieEnjoyDrinkingVC
    
    private let navigationBarManager = NavigationBarManager()
    
    let cellData = ["소주", "맥주", "위스키", "칵테일", "막걸리", "사케", "고량주", "보드카", "브랜디", "데킬라"]
    
    private var selectedItems: [String] = []
    private let maxSelectionCount = 2
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background
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
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
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
    
    private lazy var surveyKindView = SurveyKindView(titleText: "평소 즐겨마시는\n주종을 골라주세요(2개 선택)", currentPage: 1, entirePage: 3, buttonTitle: "다음").then {
        $0.surveyKindCollectionView.delegate = self
        $0.surveyKindCollectionView.dataSource = self
        
        $0.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc func nextButtonTapped() {
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.nextBtnTapped, fileName: #file)
        UserSurveyManager.shared.calculateDrinkType(selectedItems)
        let vc = NewbieFoodViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension NewbieEnjoyDrinkingViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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
        logCellClick(screenName: screenName, indexPath: indexPath, cellName: Tracking.CellEvent.shortSurveyCellTapped, fileName: #file, cellID: SurveyKindCollectionViewCell.identifier)
        let selectedItem = cellData[indexPath.row]
        
        if selectedItems.contains(selectedItem) { //이미 selected된 cell
            selectedItems.removeAll { $0 == selectedItem }
        } else {
            if selectedItems.count >= maxSelectionCount { // 이미 2개 선택
                showToastMessage(message: "선택할 수 있는 갯수를 초과했습니다.", yPosition: view.frame.height * 0.75)
                return
            }
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
        let font = UIFont.pretendard(.medium, size: 16)
        let size = title.size(withAttributes: [.font: font])
        
        let padding: CGFloat = DynamicPadding.dynamicValue(40.0)
        let cellWidth = size.width + padding
        
        return CGSize(width: cellWidth, height: DynamicPadding.dynamicValue(49.0))
    }
}

