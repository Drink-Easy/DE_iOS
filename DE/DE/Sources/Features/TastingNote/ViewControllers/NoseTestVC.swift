// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

// 향 선택 뷰컨

public class NoseTestVC: UIViewController {
    let topView = NoseTopView() // 기본 상단 뷰
    let middleView = NoseBottomView() // 중간 뷰
//    let middleView = OnlyScrollView()
    let navigationBarManager = NavigationBarManager()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        setupUI()
        setupCollectionView()
        setupActions()
        setupNavigationBar()
    }
    
    private func setupUI() {
        topView.header.setTitleLabel("아무와인이나넣어")
        topView.propertyHeader.setName(eng: "Nose", kor: "향")
        [topView, middleView].forEach{ view.addSubview($0) }
        
        topView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(10.0))
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24.0))
            make.height.greaterThanOrEqualTo(350)
        }
        
        middleView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(DynamicPadding.dynamicValue(45.0))
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24.0))
            make.bottom.equalToSuperview() // 바닥까지 확장
        }
    }
    
    private func setupCollectionView() {
        // 레이아웃 설정
        let selectedCollectionView = topView.selectedCollectionView
        selectedCollectionView.tag = 1
        selectedCollectionView.delegate = self
        selectedCollectionView.dataSource = self
        selectedCollectionView.register(NoseCollectionViewCell.self, forCellWithReuseIdentifier: NoseCollectionViewCell.identifier)
        
        let noseCollectionView = middleView.noseCollectionView
        noseCollectionView.tag = 0
        noseCollectionView.delegate = self
        noseCollectionView.dataSource = self
        
        noseCollectionView.register(NoseCollectionViewCell.self, forCellWithReuseIdentifier: NoseCollectionViewCell.identifier)
        noseCollectionView.register(NoseCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NoseCollectionReusableView.identifier)

    }
    
    private func setupActions() {
        middleView.nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
    }
    
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
        print(NoseManager.shared.selectedScents)
        
        let nextVC = RecordGraphViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension NoseTestVC : UICollectionViewDelegate, UICollectionViewDataSource {
    /// 섹션 수
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.tag == 0 { // noseCollectionView
            return NoseManager.shared.scentSections.count
        } else if collectionView.tag == 1 { // selectedCollectionView
            return 1
        }
        return 0
    }
    
    /// 각 섹션의 아이템 수 - 접혀있으면 0으로 고정
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            if NoseManager.shared.scentSections[section].isExpand { // 열려있는 상태
                return NoseManager.shared.scentSections[section].scents.count
            } else { // 닫혀있는 상태
                return 0
            }
        } else if collectionView.tag == 1 {
            return NoseManager.shared.selectedScents.count
        }
        return 0
    }
    
    /// 셀에 데이터 넣어주는 함수
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoseCollectionViewCell.identifier, for: indexPath) as? NoseCollectionViewCell else {
            fatalError("셀 등록 실패")
        }
        
        if collectionView.tag == 0 {
            let item = NoseManager.shared.scentSections[indexPath.section].scents[indexPath.row]
            cell.menuLabel.text = item.name
            
            if item.isSelected { // 선택 항목 -> 컬러 넣어주기
                cell.menuView.backgroundColor = AppColor.purple10
                cell.menuLabel.textColor = AppColor.purple100
                cell.menuView.layer.borderColor = AppColor.purple70?.cgColor
            } else { // 선택되지 않은 항목
                cell.menuView.backgroundColor = AppColor.gray10
                cell.menuLabel.textColor = AppColor.gray100
                cell.menuView.layer.borderColor = UIColor.clear.cgColor
            }
        } else if collectionView.tag == 1 {// 선택 항목 -> 컬러 넣어주기
            let scent = NoseManager.shared.selectedScents[indexPath.row]
            cell.menuLabel.text = scent.name
            
            cell.menuView.backgroundColor = AppColor.purple10
            cell.menuLabel.textColor = AppColor.purple100
            cell.menuView.layer.borderColor = AppColor.purple70?.cgColor
        }
        
        return cell
    }
    
    /// 헤더 설정
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        if collectionView.tag == 1 {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: NoseCollectionReusableView.identifier,
            for: indexPath
        ) as! NoseCollectionReusableView
        
        let section = NoseManager.shared.scentSections[indexPath.section]
        
        // 상태(isExpanded) 전달 - 헤더 configure 함수 호출
        header.configure(with: section.header, section: indexPath.section, delegate: self, isExpanded: section.isExpand)
        return header
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 { // 선택 & 선택 해제
            var item = NoseManager.shared.scentSections[indexPath.section].scents[indexPath.row]
            item.isSelected.toggle()
        } else if collectionView.tag == 1 {
            var item = NoseManager.shared.selectedScents[indexPath.row]
            item.isSelected.toggle()
        }
        
        collectionView.reloadItems(at: [indexPath])
        
        // 아이템 개수 변동에 따른 콜렉션뷰 길이 업데이트
//        self.topView.updateSelectedCollectionViewHeight()
        self.middleView.updateNoseCollectionViewHeight()
    }
    
}

extension NoseTestVC: NoseHeaderViewDelegate {
    // 토글 애니메이션 추가
    func toggleSection(_ section: Int) {
        NoseManager.shared.scentSections[section].isExpand.toggle()
        
        // 애니메이션 적용
        let indexSet = IndexSet(integer: section)
        middleView.noseCollectionView.performBatchUpdates({
            middleView.noseCollectionView.reloadSections(indexSet)
        }, completion: nil)
    }
}

extension NoseTestVC: UICollectionViewDelegateFlowLayout {
    /// 섹션 간 여백
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0) // 좌우 여백 10
    }
    
    /// 셀 간 가로 간격(셀 옆 간격)
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    /// 셀 간 세로 간격(줄 간격)
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // 각 셀의 크기
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let totalSpacing = (itemsPerRow - 1) * 10 + 20 // 셀 간 간격 + 좌우 여백(10씩)
        let itemWidth = (collectionView.frame.width - totalSpacing) / itemsPerRow
        return CGSize(width: itemWidth, height: 40)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView.tag == 1 {
            // selectedCollectionView의 헤더 크기를 0으로 설정
            return CGSize.zero
        }
        return CGSize(width: collectionView.frame.width, height: 52) // 기본 헤더 크기
    }
}
