//
//  TastedDateView.swift
//  Drink-EG
//
//  Created by 이수현 on 10/30/24.
//

import UIKit

class TastedDateView: UIView {

    let wineName: UILabel = {
        let w = UILabel()
        w.text = "루이 로드레 크리스탈 2015"
        w.textColor = UIColor(hex: "#7E13B1")
        w.font = UIFont.ptdSemiBoldFont(ofSize: 24)
        return w
    }()
    
    let label: UILabel = {
        let l = UILabel()
        l.text = "시음 시기를 선택해주세요"
        l.textColor = .black
        l.font = UIFont.ptdSemiBoldFont(ofSize: 24)
        return l
    }()
    
    private var calender: UICalendarView = {
        let c = UICalendarView()
        c.calendar = .current
        c.locale = .current
        c.fontDesign = .rounded
        c.layer.cornerRadius = 10
        c.wantsDateDecorations = true
        c.tintColor = UIColor(hex: "#7E13B1")
        return c
    }()
    
    let nextButton: UIButton = {
        let n = UIButton()
        n.setTitle("다음", for: .normal)
        n.titleLabel?.font = UIFont.ptdBoldFont(ofSize: 18)
        n.backgroundColor = UIColor(hex: "#7E13B1")
        n.layer.cornerRadius = 14
        n.setTitleColor(.white, for: .normal)
        return n
    }()
    
    func setupUI() {
        backgroundColor = .white
        
        addSubview(wineName)
        wineName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(110)
            make.leading.equalToSuperview().offset(25)
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
            make.height.equalTo(293)
        }
        
        addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-42)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(28)
            make.height.equalTo(56)
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
