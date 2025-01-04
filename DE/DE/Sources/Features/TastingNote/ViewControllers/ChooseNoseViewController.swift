// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

public class ChooseNoseViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    var sections: [NoseSectionModel] = NoseSectionModel.sections() // 섹션 데이터
    var selectedItems: [String:[NoseModel]] = [:]
    
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

extension ChooseNoseViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // 섹션 수
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView.tag == 0 {
            return sections.count
        } else if collectionView.tag == 1 {
            return 1
        }
        return 0
    }
    
    // 각 섹션의 아이템 수 - 접혀있으면 0으로 고정
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return sections[section].isExpanded ? sections[section].items.count : 0
        } else if collectionView.tag == 1 {
            let allSelectedItems = selectedItems.values.flatMap { $0 } // 모든 섹션의 아이템 합침
            return allSelectedItems.count
        }
        return 0
    }
    
    // 셀 설정
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoseCollectionViewCell.identifier, for: indexPath) as? NoseCollectionViewCell else {
            fatalError("셀 등록 실패")
        }
        
        if collectionView.tag == 0 {
            // tag == 0: 전체 항목
            let item = sections[indexPath.section].items[indexPath.item]
            cell.menuLabel.text = item.type
            
            let sectionTitle = sections[indexPath.section].sectionTitle
            if let selectedItems = selectedItems[sectionTitle], selectedItems.contains(where: { $0.type == item.type }) {
                cell.menuView.backgroundColor = AppColor.purple10
                cell.menuLabel.textColor = AppColor.purple100
                cell.menuView.layer.borderColor = AppColor.purple100?.cgColor
            } else {
                cell.menuView.backgroundColor = AppColor.gray40
                cell.menuLabel.textColor = AppColor.gray100
                cell.menuView.layer.borderColor = UIColor.clear.cgColor
            }
        } else if collectionView.tag == 1 {
            // tag == 1: 선택된 항목
            let keys = Array(selectedItems.keys)
            let key = keys[indexPath.section]
            if let item = selectedItems[key]?[indexPath.item] {
                cell.menuLabel.text = item.type
                cell.menuView.backgroundColor = AppColor.purple10
                cell.menuLabel.textColor = AppColor.purple100
                cell.menuView.layer.borderColor = AppColor.purple100?.cgColor
            }
        }
        return cell
    }
    
    // 헤더 설정
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        
        if collectionView.tag == 1 {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "Header",
            for: indexPath
        ) as! NoseCollectionReusableView
        
        let section = sections[indexPath.section]
        // 상태(isExpanded) 전달 - 헤더 configure 함수 호출
        header.configure(with: section.sectionTitle, section: indexPath.section, delegate: self, isExpanded: section.isExpanded)
        return header
    }
}

extension ChooseNoseViewController: NoseHeaderViewDelegate {
    // 토글 애니메이션에 대한 것
    func toggleSection(_ section: Int) {
        sections[section].isExpanded.toggle()
        
        // 애니메이션 적용
        let indexSet = IndexSet(integer: section)
        chooseNoseView.collectionView.performBatchUpdates({
            chooseNoseView.collectionView.reloadSections(indexSet)
        }, completion: nil)
    }
}

extension ChooseNoseViewController: UICollectionViewDelegateFlowLayout {
    // 섹션 간 여백
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // 좌우 여백 10
    }
    
    // 셀 간 가로 간격
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // 셀 간 간격
    }
    
    // 셀 간 세로 간격
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // 줄 간 간격
    }
    
    // 각 셀의 크기
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3 // 한 줄에 표시될 셀의 개수
        let totalSpacing = (itemsPerRow - 1) * 10 + 20 // 셀 간 간격 + 좌우 여백(10씩)
        let itemWidth = (collectionView.frame.width - totalSpacing) / itemsPerRow
        return CGSize(width: itemWidth, height: 50) // 셀 높이는 고정
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView.tag == 1 {
            // selectedCollectionView의 헤더 크기를 0으로 설정
            return CGSize.zero
        }
        return CGSize(width: collectionView.frame.width, height: 50) // 기본 헤더 크기
    }
}

extension ChooseNoseViewController {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 0 {
            // 첫 번째 컬렉션 뷰: 전체 항목
            let section = indexPath.section
            let sectionTitle = sections[section].sectionTitle
            let item = sections[section].items[indexPath.item]
            
            if selectedItems[sectionTitle] == nil {
                selectedItems[sectionTitle] = []
            }
            
            if let index = selectedItems[sectionTitle]?.firstIndex(where: { $0.type == item.type }) {
                // 이미 선택된 항목 -> 선택 해제
                selectedItems[sectionTitle]?.remove(at: index)
                if selectedItems[sectionTitle]?.isEmpty == true {
                    selectedItems.removeValue(forKey: sectionTitle)
                }
            } else {
                // 새로 선택된 항목
                selectedItems[sectionTitle]?.append(item)
            }
            
            // tag == 0 및 tag == 1 컬렉션 뷰 모두 업데이트
            collectionView.reloadItems(at: [indexPath])
            chooseNoseView.selectedCollectionView.reloadData()
            chooseNoseView.updateSelectedCollectionViewHeight()
            chooseNoseView.updateNoseCollectionViewHeight()
        }
    }
}

protocol NoseHeaderViewDelegate: AnyObject {
    func toggleSection(_ section: Int) // 섹션 상태 토글을 위한 델리게이트 메서드
}
