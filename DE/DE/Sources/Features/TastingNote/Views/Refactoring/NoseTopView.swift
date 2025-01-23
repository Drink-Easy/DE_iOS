// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import SnapKit

// 향 상단 뷰 pageCount ~ 향 설명까지

class NoseTopView: UIView {
    public lazy var header = TopView(currentPage: 3, entirePage: 5)
    public lazy var propertyHeader = PropertyTitleView(type: .nose)

    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let noseDescription = UILabel().then {
        $0.text = "와인을 시음하기 전, 향을 맡아보세요! 와인 잔을 천천히 돌려 잔의 표면에 와인을 묻히면 잔 속에 향이 풍부하게 느껴져요."
        $0.font = UIFont.ptdRegularFont(ofSize: 14)
        $0.textColor = AppColor.gray90
        $0.numberOfLines = 0
    }
    
    private func addComponents() {
        [header, propertyHeader, noseDescription].forEach{ addSubview($0) }
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
    }
    
}

