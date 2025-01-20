// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

import SnapKit
import Then

class SelectColorView: UIView {
    public lazy var header = TopView(currentPage: 2, entirePage: 5)
    public lazy var infoView = WineDetailView()
    public lazy var propertyHeader = PropertyTitleView(engName: "Color", korName: "색상")
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
    
    public lazy var nextButton = CustomButton(title: "다음", isEnabled: false)

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
            make.top.equalTo(header.snp.bottom).offset(20) // TODO : 동적 기기 대응
            make.leading.trailing.equalToSuperview()
        }
        
        propertyHeader.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(50) // TODO : 동적 기기 대응
            make.leading.trailing.equalToSuperview()
        }
        
        colorCollectionView.snp.makeConstraints { make in
            make.top.equalTo(propertyHeader.snp.bottom).offset(20) // 동적 기기 대응
            make.leading.trailing.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(40) // 동적 기기 대응
            make.leading.trailing.equalToSuperview()
        }
    }
    
}
