// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Then
import Network

class BuyNewWineDateView: UIView {
    
    private let scrollView: UIScrollView = {
        let s = UIScrollView()
        s.backgroundColor = .clear
        return s
    }()
    
    private let contentView: UIView = {
        let c = UIView()
        c.backgroundColor = AppColor.gray20
        return c
    }()
    
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
        $0.numberOfLines = 0
    }
    
    let label = UILabel().then {
        $0.text = "구매 일자를 입력해주세요"
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
        $0.tintColor = AppColor.purple100
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
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        contentView.addSubview(pageLabel)
        pageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(24)
        }
        
        contentView.addSubview(wineName)
        wineName.snp.makeConstraints { make in
            make.top.equalTo(pageLabel.snp.bottom).offset(2)
            make.leading.equalTo(pageLabel)
            make.trailing.equalToSuperview().offset(-25)
        }
        
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(wineName.snp.bottom).offset(1)
            make.leading.equalTo(wineName.snp.leading)
            
        }
        
        contentView.addSubview(calender)
        calender.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(36)
            make.leading.equalToSuperview().offset(21)
            make.centerX.equalToSuperview()
            make.height.equalTo(Constants.superViewHeight*0.5)
        }
        
        contentView.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(calender.snp.bottom).offset(130)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(28)
            make.height.equalTo(Constants.superViewHeight*0.06)
        }
        
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.bottom).offset(40)
        }
    }

    func updateUI(wineName: String) {
        self.wineName.text = wineName
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


