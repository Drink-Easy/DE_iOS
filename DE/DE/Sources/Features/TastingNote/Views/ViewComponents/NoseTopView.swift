// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import DesignSystem
import SnapKit

// 향 상단 뷰 pageCount ~ 향 설명까지

class NoseTopView: UIView {
    public lazy var header = TopView(currentPage: 3, entirePage: 5)
    public lazy var propertyHeader = PropertyTitleView(type: .nose)
    private let noseDescription = UILabel().then {
        $0.text = "와인을 시음하기 전, 향을 맡아보세요! 와인 잔을 천천히 돌려 잔의 표면에 와인을 묻히면 잔 속에 향이 풍부하게 느껴져요."
        $0.font = .pretendard(.regular, size: 14)
        $0.textColor = AppColor.gray90
        $0.numberOfLines = 0
    }
    
    private let selectedLabel = UILabel().then {
        $0.text = "선택된 항목"
        $0.font = .pretendard(.semiBold, size: 18)
        $0.textColor = AppColor.purple100
    }
    
    var layout = NewLeftAlignedCollectionViewFlowLayout().then {
        $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        $0.minimumInteritemSpacing = 10
        $0.minimumLineSpacing = 12
    }
    
    public lazy var selectedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.backgroundColor = .clear
        $0.tag = 1
        $0.isScrollEnabled = false
    }
    

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
            make.top.equalTo(header.snp.bottom).offset(DynamicPadding.dynamicValue(40))
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(30)
        }
        
        noseDescription.snp.makeConstraints { make in
            make.top.equalTo(propertyHeader.snp.bottom).offset(DynamicPadding.dynamicValue(12))
            make.leading.trailing.equalToSuperview()
        }
        
        selectedLabel.snp.makeConstraints { make in
            make.top.equalTo(noseDescription.snp.bottom).offset(DynamicPadding.dynamicValue(30))
            make.leading.trailing.equalToSuperview()
        }
        
        selectedCollectionView.snp.makeConstraints { make in
            make.top.equalTo(selectedLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(DynamicPadding.dynamicValue(20))
            make.bottom.equalToSuperview()
        }
    }
    
    public func updateTopViewHeight() {
        self.layoutIfNeeded() // 레이아웃 강제 업데이트
        let newHeight = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        
        // NoseTopView의 높이 제약 조건 업데이트
        self.snp.updateConstraints { make in
            make.height.equalTo(newHeight)
        }
    }
    
    func updateSelectedCollectionViewHeight() {
        selectedCollectionView.layoutIfNeeded() // 레이아웃 업데이트
        let contentHeight = selectedCollectionView.contentSize.height
        selectedCollectionView.snp.updateConstraints { make in
            make.height.equalTo(contentHeight + DynamicPadding.dynamicValue(10))
        }
    }
}
