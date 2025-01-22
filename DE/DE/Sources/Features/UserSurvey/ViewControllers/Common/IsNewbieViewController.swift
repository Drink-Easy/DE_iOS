// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Then
import SnapKit

public class IsNewbieViewController: UIViewController {
    
    private let navigationBarManager = NavigationBarManager()
    
    let cellData = [IsNewbieModel(emoji: "👦", contents: "나는 내 와인 취향을 모른다"), IsNewbieModel(emoji: "🧑‍🏫", contents: "나는 나의 와인 취향에\n대해 잘 알고 있다.")]
    
    var isNewbie: Bool?

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        self.view = isNewbieView
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
    
    private lazy var isNewbieView = IsNewbieView().then {
        $0.isNewbieCollectionView.delegate = self
        $0.isNewbieCollectionView.dataSource = self
        
        $0.startButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc func nextButtonTapped() {
        // 정보 저장
        guard let isnewbie = self.isNewbie else { return }
        UserSurveyManager.shared.setUserType(isNewbie: isnewbie)
        let vc = isnewbie ? NewbieEnjoyDrinkingViewController() : ManiaConsumeViewController()
        navigationController?.pushViewController(vc, animated: true)
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
}

extension IsNewbieViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellData.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IsNewbieCollectionViewCell.identifier, for: indexPath) as! IsNewbieCollectionViewCell
        
        cell.configure(model: cellData[indexPath.row])
        cell.updateSelectionState(isSelected: cell.isSelected)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for cell in collectionView.visibleCells {
            if let cell = cell as? IsNewbieCollectionViewCell {
                cell.updateSelectionState(isSelected: false)  // 모든 셀 선택 해제
            }
        }
        
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? IsNewbieCollectionViewCell {
            selectedCell.updateSelectionState(isSelected: true)  // 클릭한 셀만 선택
        }
        isNewbieView.startButton.isEnabled = true
        isNewbieView.startButton.isEnabled(isEnabled: true)
        isNewbie = indexPath.row == 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let aspectRatio: CGFloat = 100.0 / 342.0
        let width = collectionView.bounds.width  
        let height = width * aspectRatio
        
        return CGSize(width: width, height: height)
    }
}
