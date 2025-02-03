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
    //TODO: 내 노트 검색
    let searchButton = UIButton().then {
        $0.setImage(UIImage(named: "searchBarIcon")?.withTintColor(AppColor.gray70 ?? .black, renderingMode: .alwaysOriginal), for: .normal)
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
    lazy var noTastingNoteLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "작성된 테이스팅 노트가 없어요.\n나의 경험을 기록해 보세요!"
        $0.setLineSpacingPercentage(0.3)
        $0.font = UIFont.ptdRegularFont(ofSize: 14)
        $0.textColor = AppColor.gray70
        $0.textAlignment = .center
        $0.isHidden = true
    }
    lazy var TastingNoteCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let screenWidth = UIScreen.main.bounds.width
        let itemsPerRow: CGFloat = 3
        let totalSpacing = (screenWidth / (itemsPerRow * 2 - 1)) * 0.3
        let itemWidth = (screenWidth - totalSpacing * 3) / 3
        
        if let layout = $0.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: itemWidth, height: itemWidth + totalSpacing * 2)
            layout.minimumInteritemSpacing = totalSpacing * 0.3
            layout.minimumLineSpacing = totalSpacing * 0.5
            layout.sectionInset = UIEdgeInsets(top: 0, left: totalSpacing * 0.6, bottom: 0, right: totalSpacing * 0.6)
        }
        
        $0.backgroundColor = .clear
        $0.register(TastingNoteCollectionViewCell.self, forCellWithReuseIdentifier: "TastingNoteCollectionViewCell")
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
        [titleLabel, searchButton, topDividerView, wineImageStackView, tnLabel, TastingNoteCollectionView, noTastingNoteLabel].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(safeAreaLayoutGuide).inset(24)
        }
        searchButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalTo(safeAreaLayoutGuide).inset(16)
            $0.size.equalTo(25)
        }
        topDividerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(2)
        }
        wineImageStackView.snp.makeConstraints {
            $0.top.equalTo(topDividerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        tnLabel.snp.makeConstraints {
            $0.top.equalTo(wineImageStackView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().inset(24)
        }
        TastingNoteCollectionView.snp.makeConstraints {
            $0.top.equalTo(tnLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview()
        }
        noTastingNoteLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerY.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
