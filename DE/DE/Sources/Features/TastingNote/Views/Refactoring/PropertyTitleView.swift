// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Then
import CoreModule
import SnapKit

/// 와인 정보 속성 헤더
class PropertyTitleView: UIView {
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
    
    private lazy var editButton = UIButton().then {
        $0.setAttributedTitle(
            NSAttributedString(
                string: "수정하기",
                attributes: [
                    .font: UIFont.ptdRegularFont(ofSize: 12), // 폰트 적용
                    .underlineStyle: NSUnderlineStyle.single.rawValue,    // 밑줄 스타일
                    .foregroundColor: AppColor.gray90!                // 텍스트 색상 (필요 시)
                ]
            ),
            for: .normal
        )
        $0.isHidden = true
    }
    
    private lazy var dateLabel = UILabel().then {
        $0.textColor = AppColor.gray90
        $0.font = UIFont.ptdRegularFont(ofSize: 12)
    }
    
    /// 기본 컬러가 보라50임
    init(barColor : UIColor = AppColor.purple50!) {
        super.init(frame: .zero)
        backgroundColor = .clear
        self.line.backgroundColor = barColor
        
        self.addComponents()
        self.constraints()
    }
    
    public func setName(eng engTitle : String, kor korTitle : String) {
        self.engTitle.text = engTitle
        self.korTitle.text = korTitle
    }
    
    public func setType(showEditButton: Bool = false, showDateLabel: Bool = false) {
        self.editButton.isHidden = !showEditButton
        self.dateLabel.isHidden = !showDateLabel
    }
    
    public func setDate(reviewDate: String) {
        self.dateLabel.text = reviewDate
        self.dateLabel.isHidden = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func addComponents() {
        [engTitle, korTitle, line, editButton, dateLabel].forEach{ self.addSubview($0) }
    }
    
    private func constraints() {
        engTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        korTitle.snp.makeConstraints { make in
            make.bottom.equalTo(engTitle.snp.bottom).inset(2)
            make.leading.equalTo(engTitle.snp.trailing).offset(6) // 폰트 사이즈 변화 없어서 6 고정
        }
        
        line.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(engTitle.snp.bottom).offset(6)
            make.height.equalTo(1)
        }
        
        editButton.snp.makeConstraints { make in
            make.bottom.equalTo(engTitle.snp.bottom).offset(2)
            make.trailing.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(engTitle.snp.bottom).offset(2)
            make.trailing.equalToSuperview()
        }
        
    }
}

