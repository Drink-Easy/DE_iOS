//
//  ChooseTypeViewController.swift
//  Drink-EG
//
//  Created by 이수현 on 12/17/24.
//

import UIKit

public class ChooseNoseViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private let sections = NoseSectionModel.sections()
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return sections[0].items.count
        case 1:
            return sections[1].items.count
        case 2:
            return sections[2].items.count
        case 3:
            return sections[3].items.count
        case 4:
            return sections[4].items.count
        case 5:
            return sections[5].items.count
        case 6:
            return sections[6].items.count
        default:
            return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NoseCollectionViewCell.identifier,
            for: indexPath
        ) as? NoseCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        switch collectionView.tag {
        case 0:
            cell.menuLabel.text = sections[0].items[indexPath.row].type
        case 1:
            cell.menuLabel.text = sections[1].items[indexPath.row].type
        case 2:
            cell.menuLabel.text = sections[2].items[indexPath.row].type
        case 3:
            cell.menuLabel.text = sections[3].items[indexPath.row].type
        case 4:
            cell.menuLabel.text = sections[4].items[indexPath.row].type
        case 5:
            cell.menuLabel.text = sections[5].items[indexPath.row].type
        case 6:
            cell.menuLabel.text = sections[6].items[indexPath.row].type
        default:
            cell.menuLabel.text = ""
        }
    
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: NoseCollectionReusableView.identifer,
                for: indexPath
              ) as? NoseCollectionReusableView else {
            return UICollectionReusableView()
        }
        
        // 헤더 데이터 설정
        switch collectionView.tag {
        case 0:
            header.titleLabel.text = sections[0].sectionTitle
        case 1:
            header.titleLabel.text = sections[1].sectionTitle
        case 2:
            header.titleLabel.text = sections[2].sectionTitle
        case 3:
            header.titleLabel.text = sections[3].sectionTitle
        case 4:
            header.titleLabel.text = sections[4].sectionTitle
        case 5:
            header.titleLabel.text = sections[5].sectionTitle
        case 6:
            header.titleLabel.text = sections[6].sectionTitle
        default:
            header.titleLabel.text = ""
        }
        return header
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? NoseCollectionViewCell else { return }
        cell.menuView.backgroundColor = UIColor(hex: "#EEE1F0") // 선택된 셀의 배경색 변경
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? NoseCollectionViewCell else { return }
        cell.menuView.backgroundColor = .clear // 선택 해제된 셀의 배경색 초기화
    }
    
    let chooseNoseView = ChooseNoseView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupDelegate()
    }
    
    func setupUI() {
        view.addSubview(chooseNoseView)
        chooseNoseView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupDelegate() {
        chooseNoseView.flowersCollectionView.dataSource = self
        chooseNoseView.flowersCollectionView.delegate = self
        chooseNoseView.fruitsCollectionView.dataSource = self
        chooseNoseView.fruitsCollectionView.delegate = self
        chooseNoseView.vegetablesCollectionView.dataSource = self
        chooseNoseView.vegetablesCollectionView.delegate = self
        chooseNoseView.spicesCollectionView.dataSource = self
        chooseNoseView.spicesCollectionView.delegate = self
        chooseNoseView.chemsCollectionView.dataSource = self
        chooseNoseView.chemsCollectionView.delegate = self
        chooseNoseView.animalsCollectionView.dataSource = self
        chooseNoseView.animalsCollectionView.delegate = self
        chooseNoseView.burnsCollectionView.dataSource = self
        chooseNoseView.burnsCollectionView.delegate = self
        
        chooseNoseView.flowersCollectionView.allowsMultipleSelection = true
        chooseNoseView.fruitsCollectionView.allowsMultipleSelection = true
        chooseNoseView.vegetablesCollectionView.allowsMultipleSelection = true
        chooseNoseView.spicesCollectionView.allowsMultipleSelection = true
        chooseNoseView.chemsCollectionView.allowsMultipleSelection = true
        chooseNoseView.animalsCollectionView.allowsMultipleSelection = true
        chooseNoseView.burnsCollectionView.allowsMultipleSelection = true
    }
    
    
    
}
