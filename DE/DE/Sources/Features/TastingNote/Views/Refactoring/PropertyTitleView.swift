// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Then
import CoreModule
import SnapKit

/// 와인 정보 속성 헤더
class PropertyTitleView: UIView {
    var engName: String?
    var korName: String?
    
    private lazy var engTitle = UILabel().then {
        $0.textColor = AppColor.black
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 22)
        $0.textAlignment = .left
    }
    
    private lazy var korTitle = UILabel().then {
        $0.textColor = AppColor.gray90
        $0.font = UIFont.ptdRegularFont(ofSize: 14)
        $0.textAlignment = .left
    }
    
    private lazy var line = UIView()
    
    /// 기본 컬러가 보라50임
    init(engName: String = "Property", korName: String = "속성", barColor : UIColor = AppColor.purple50!) {
        super.init(frame: .zero)
        backgroundColor = .clear
        self.engName = engName
        self.korName = korName
        self.line.backgroundColor = barColor
        
        self.addComponents()
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func addComponents() {
        [engTitle, korTitle, line].forEach{ self.addSubview($0) }
    }
    
    private func constraints() {
        engTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        engTitle.sizeToFit()
        
        korTitle.snp.makeConstraints { make in
            make.bottom.equalTo(engTitle.snp.bottom)
            make.leading.equalTo(engTitle.snp.trailing).offset(6) // 폰트 사이즈 변화 없어서 6 고정
        }
        korTitle.sizeToFit()
        
        line.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(engTitle.snp.bottom).offset(6)
            make.height.equalTo(1)
        }
        
    }
}

