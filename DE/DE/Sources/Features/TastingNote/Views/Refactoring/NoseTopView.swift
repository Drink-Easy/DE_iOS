// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import SnapKit

// 향 상단 뷰 pageCount ~ 향 설명까지

class NoseTopView: UIView {
    public lazy var header = TopView(currentPage: 3, entirePage: 5)
    public lazy var propertyHeader = PropertyTitleView(type: .nose)
    private let noseDescription = UILabel().then {
        $0.text = "와인을 시음하기 전, 향을 맡아보세요! 와인 잔을 천천히 돌려 잔의 표면에 와인을 묻히면 잔 속에 향이 풍부하게 느껴져요."
        $0.font = UIFont.ptdRegularFont(ofSize: 14)
        $0.textColor = AppColor.gray90
        $0.numberOfLines = 0
    }
    
    private let selectedLabel = UILabel().then {
        $0.text = "선택된 항목"
        $0.font = .ptdSemiBoldFont(ofSize: 18)
        $0.textColor = AppColor.purple100
    }
    public lazy var selectedCollectionView = UICollectionView()
    
//    let selectedCollectionView: UICollectionView = {
//        let layout = LeftAlignedCollectionViewFlowLayout()
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        layout.minimumInteritemSpacing = 10
//        layout.minimumLineSpacing = 10
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
//        layout.headerReferenceSize = CGSize(width: Constants.superViewWidth - 48, height: 50) // 헤더 가로사이즈 superview에 맞게하고싶음
//        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        cv.backgroundColor = .clear
//        cv.tag = 1
//        return cv
//    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        [header, propertyHeader, noseDescription, selectedLabel, selectedCollectionView].forEach{ addSubview($0) }
    }
    
    private func setConstraints() {
        header.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        propertyHeader.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(40) // TODO : 동적 기기 대응
            make.leading.trailing.equalToSuperview()
        }
        
        noseDescription.snp.makeConstraints { make in
            make.top.equalTo(propertyHeader.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
        }
        
        selectedLabel.snp.makeConstraints { make in
            make.top.equalTo(noseDescription.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
        }
        
        selectedCollectionView.snp.makeConstraints { make in
            make.top.equalTo(selectedLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(DynamicPadding.dynamicValue(150))
        }
    }
    
}
