// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Then
import CoreModule

public class DescriptionUIView: UIView {

    let backgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 14
    }
    
    let kindLabel = UILabel().then {
        $0.text = "종류"
        $0.font = .ptdSemiBoldFont(ofSize: 14)
        $0.textColor = UIColor(hex: "#7E13B1")
        $0.textAlignment = .center
    }
    
    let kindDescription = UILabel().then {
        $0.text = "스파클링 와인, 샴페인"
        $0.font = .ptdMediumFont(ofSize: 12)
        $0.textColor = UIColor(hex: "#606060")
        $0.textAlignment = .left
    }
    
    let breedLabel = UILabel().then {
        $0.text = "품종"
        $0.font = .ptdSemiBoldFont(ofSize: 14)
        $0.textColor = UIColor(hex: "#7E13B1")
        $0.textAlignment = .center
    }
    
    let breedDescription = UILabel().then {
        $0.text = "피노누아(60%), 샤르도네(40%)"
        $0.font = .ptdMediumFont(ofSize: 12)
        $0.textColor = UIColor(hex: "#606060")
        $0.textAlignment = .left
    }
    
    let fromLabel = UILabel().then {
        $0.text = "생산지"
        $0.font = .ptdSemiBoldFont(ofSize: 14)
        $0.textColor = UIColor(hex: "#7E13B1")
        $0.textAlignment = .center
    }
    
    let fromDescription = UILabel().then {
        $0.text = "프랑스, 상파뉴"
        $0.font = .ptdMediumFont(ofSize: 12)
        $0.textColor = UIColor(hex: "#606060")
        $0.textAlignment = .left
    }

    func setupUI() {
        backgroundColor = .clear
        addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundView.addSubview(breedLabel)
        breedLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(13)
        }
        
        backgroundView.addSubview(breedDescription)
        breedDescription.snp.makeConstraints { make in
            make.top.equalTo(breedLabel)
            make.leading.equalTo(breedLabel.snp.trailing).offset(30)
        }
        
        backgroundView.addSubview(kindLabel)
        kindLabel.snp.makeConstraints { make in
            make.bottom.equalTo(breedLabel.snp.top).offset(-8)
            make.leading.equalTo(breedLabel.snp.leading)
        }
        
        backgroundView.addSubview(kindDescription)
        kindDescription.snp.makeConstraints { make in
            make.top.equalTo(kindLabel.snp.top)
            make.leading.equalTo(kindLabel.snp.trailing).offset(30)
        }
        
        backgroundView.addSubview(fromLabel)
        fromLabel.snp.makeConstraints { make in
            make.top.equalTo(breedLabel.snp.bottom).offset(8)
            make.leading.equalTo(breedLabel.snp.leading)
        }
        
        backgroundView.addSubview(fromDescription)
        fromDescription.snp.makeConstraints { make in
            make.top.equalTo(fromLabel)
            make.leading.equalTo(kindDescription.snp.leading)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }
    
    public required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
