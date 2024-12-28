//
//  TastedDateView.swift
//  Drink-EG
//
//  Created by 이수현 on 10/30/24.
//

import UIKit
import CoreModule
import Then

class TastedDateView: UIView {

    let pageLabel = UILabel().then {
        $0.textColor = AppColor.gray80
        let fullText = "1/5"
        let coloredText = "1"
        let attributedString = fullText.withColor(for: coloredText, color: AppColor.purple70 ?? UIColor(hex: "9741BF")!)
        $0.attributedText = attributedString
        $0.font = .ptdMediumFont(ofSize: 16)
    }
    
    let wineName = UILabel().then {
        $0.text = "루이 로드레 크리스탈 2015"
        $0.textColor = UIColor(hex: "#7E13B1")
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 24)
    }
    
    let label = UILabel().then {
        $0.text = "시음 시기를 선택해주세요"
        $0.textColor = .black
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 24)
    }
    
    var calender = UICalendarView().then {
        $0.backgroundColor = .white
        $0.calendar = .current
        $0.locale = .current
        $0.fontDesign = .rounded
        $0.layer.cornerRadius = 10
        $0.wantsDateDecorations = true
        $0.tintColor = UIColor(hex: "#7E13B1")
    }
    
    let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.titleLabel?.font = UIFont.ptdBoldFont(ofSize: 18)
        $0.backgroundColor = UIColor(hex: "#7E13B1")
        $0.layer.cornerRadius = 14
        $0.setTitleColor(.white, for: .normal)
    }
    
    func setupUI() {
        backgroundColor = AppColor.gray20
        
        addSubview(pageLabel)
        pageLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(24)
        }
        
        addSubview(wineName)
        wineName.snp.makeConstraints { make in
            make.top.equalTo(pageLabel.snp.bottom).offset(2)
            make.leading.equalTo(pageLabel)
        }
        
        addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(wineName.snp.bottom).offset(1)
            make.leading.equalTo(wineName.snp.leading)
            
        }
        
        addSubview(calender)
        calender.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(36)
            make.leading.equalToSuperview().offset(21)
            make.centerX.equalToSuperview()
            make.height.equalTo(Constants.superViewHeight*0.5)
        }
        
        addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-42)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(28)
            make.height.equalTo(Constants.superViewHeight*0.06)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


