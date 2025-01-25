// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule

class AllTastingNoteView: UIView {
    
    // MARK: - UI Components
    let titleLabel = UILabel().then {
        $0.text = "노트 보관함"
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 22)
        $0.textColor = AppColor.black
    }
    let searchIcon = UIImageView().then {
        $0.image = UIImage(systemName: "magnifyingglass")?.withTintColor(AppColor.gray80 ?? .black, renderingMode: .alwaysOriginal)
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    let topDividerView = UIView().then {
        $0.backgroundColor = AppColor.purple100
    }
    let wineImageStackView = WineImageStackContainerView()
    let tnLabel = UILabel().then {
        $0.text = "내 테이스팅 노트"
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 20)
        $0.textColor = AppColor.black
    }
    lazy var TastingNoteCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let screenWidth = UIScreen.main.bounds.width
        let itemsPerRow: CGFloat = 3
        let totalSpacing = (screenWidth / (itemsPerRow * 2 - 1)) * 0.3
        let itemWidth = (screenWidth - totalSpacing * 2) / 3
        
        if let layout = $0.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth + totalSpacing * 0.1)
            layout.minimumInteritemSpacing = totalSpacing * 0.3
            layout.minimumLineSpacing = totalSpacing * 2
            layout.sectionInset = UIEdgeInsets(top: 0, left: totalSpacing * 0.6, bottom: 0, right: totalSpacing * 0.6)
        }
        
        $0.backgroundColor = .clear
        $0.register(TastingNoteCollectionViewCell.self, forCellWithReuseIdentifier: "TastingNoteCollectionViewCell")
    }
    let floatingButton = UIButton(type: .system).then {
        $0.setImage(UIImage(named: "pencil"), for: .normal)
        $0.tintColor = .white
        $0.backgroundColor = AppColor.purple100
        $0.layer.cornerRadius = 25
        
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 8
        $0.layer.masksToBounds = false
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        [titleLabel, searchIcon, topDividerView, wineImageStackView, tnLabel, TastingNoteCollectionView, floatingButton].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(16)
        }
        searchIcon.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            $0.size.equalTo(25)
        }
        topDividerView.snp.makeConstraints {
            $0.top.equalTo(searchIcon.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(2)
        }
        wineImageStackView.snp.makeConstraints {
            $0.top.equalTo(topDividerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        tnLabel.snp.makeConstraints {
            $0.top.equalTo(wineImageStackView.snp.bottom).offset(16)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(16)
        }
        TastingNoteCollectionView.snp.makeConstraints {
            $0.top.equalTo(tnLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide)
        }
        floatingButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
            $0.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
}
