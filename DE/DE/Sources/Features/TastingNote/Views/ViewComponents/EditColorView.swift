// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

import SnapKit
import Then

class EditColorView: UIView {
    public lazy var header = WineNameView()
    public lazy var infoView = WineDetailView()
    public lazy var propertyHeader = PropertyTitleView(type: .color)
    public lazy var colorCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: {
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 16
            layout.minimumInteritemSpacing = 20
            layout.scrollDirection = .vertical
            return layout
        }()
    ).then {
        $0.register(WineColorCollectionViewCell.self, forCellWithReuseIdentifier: "WineColorCollectionViewCell")
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false // 스크롤 인디케이터 숨김
    }
    
    public lazy var nextButton = CustomButton(title: "저장하기", isEnabled: true)

    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addComponents()
        setConstraints()
    }
    
    public func setWineName(_ name: String) {
        self.header.setTitleLabel(name)
    }
    
    private func addComponents() {
        [header, infoView, propertyHeader, colorCollectionView, nextButton].forEach{ addSubview($0) }
    }
    
    private func setConstraints() {
        header.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(62)
        }
        
        infoView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(DynamicPadding.dynamicValue(20))
            make.leading.trailing.equalToSuperview()
        }
        
        propertyHeader.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(DynamicPadding.dynamicValue(50))
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(30)
        }
        
        colorCollectionView.snp.makeConstraints { make in
            make.top.equalTo(propertyHeader.snp.bottom).offset(DynamicPadding.dynamicValue(20))
            make.leading.trailing.equalToSuperview().inset(8)
            make.height.greaterThanOrEqualTo(270)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(DynamicPadding.dynamicValue(40))
            make.leading.trailing.equalToSuperview()
        }
    }
    
}
