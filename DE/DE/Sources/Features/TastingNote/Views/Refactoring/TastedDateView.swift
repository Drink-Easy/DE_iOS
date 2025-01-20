// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Then
import Network

class TastedDateView: UIView {
    public lazy var topView = DateTopView(currentPage: 1, entirePage: 5)
    
    var calender = UICalendarView().then {
        $0.backgroundColor = .white
        $0.calendar = .current
        $0.locale = .current
        $0.fontDesign = .rounded
        $0.layer.cornerRadius = 10
        $0.wantsDateDecorations = true
        $0.tintColor = AppColor.purple100
    }
    
    public lazy var nextButton = CustomButton(title: "다음", isEnabled: false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = AppColor.bgGray
        [topView, calender, nextButton].forEach{ addSubview($0) }
    }
    
    func setConstraints() {
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(96)
        }
        
        calender.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(<#T##amount: any ConstraintOffsetTarget##any ConstraintOffsetTarget#>)
        }
        
        nextButton.snp.makeConstraints { make in
            <#code#>
        }
    }

    func updateUI(wineName: String) {
        self.topView.setLabel(result: wineName, commonText: "시음 시기를 선택해주세요")
    }

}


