// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

class DescriptionUIView: UIView {

    let kindLabel: UILabel = {
        let k = UILabel()
        k.text = "종류"
        k.font = .ptdSemiBoldFont(ofSize: 14)
        k.textColor = UIColor(hex: "#7E13B1")
        k.textAlignment = .center
        return k
    }()
    
    let kindDescription: UILabel = {
        let k = UILabel()
        k.text = "스파클링 와인, 샴페인"
        k.font = .ptdMediumFont(ofSize: 12)
        k.textColor = UIColor(hex: "#606060")
        k.textAlignment = .left
        return k
    }()
    
    let breedLabel: UILabel = {
        let b = UILabel()
        b.text = "품종"
        b.font = .ptdSemiBoldFont(ofSize: 14)
        b.textColor = UIColor(hex: "#7E13B1")
        b.textAlignment = .center
        return b
    }()
    
    let breedDescription: UILabel = {
        let b = UILabel()
        b.text = "피노누아(60%), 샤르도네(40%)"
        b.font = .ptdMediumFont(ofSize: 12)
        b.textColor = UIColor(hex: "#606060")
        b.textAlignment = .left
        return b
    }()
    
    let fromLabel: UILabel = {
        let b = UILabel()
        b.text = "생산지"
        b.font = .ptdSemiBoldFont(ofSize: 14)
        b.textColor = UIColor(hex: "#7E13B1")
        b.textAlignment = .center
        return b
    }()
    
    let fromDescription: UILabel = {
        let b = UILabel()
        b.text = "프랑스, 상파뉴"
        b.font = .ptdMediumFont(ofSize: 12)
        b.textColor = UIColor(hex: "#606060")
        b.textAlignment = .left
        return b
    }()
    
    func setupUI() {
        addSubview(kindLabel)
        kindLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(13)
        }
        
        addSubview(kindDescription)
        kindDescription.snp.makeConstraints { make in
            make.top.equalTo(kindLabel.snp.top)
            make.leading.equalTo(kindLabel.snp.trailing).offset(30)
        }
        
        addSubview(breedLabel)
        breedLabel.snp.makeConstraints { make in
            make.top.equalTo(kindLabel.snp.bottom).offset(8)
            make.leading.equalTo(kindLabel.snp.leading)
        }
        
        addSubview(breedDescription)
        breedDescription.snp.makeConstraints { make in
            make.top.equalTo(breedLabel)
            make.leading.equalTo(kindDescription.snp.leading)
        }
        
        addSubview(fromLabel)
        fromLabel.snp.makeConstraints { make in
            make.top.equalTo(breedLabel.snp.bottom).offset(8)
            make.leading.equalTo(breedLabel.snp.leading)
        }
        
        addSubview(fromDescription)
        fromDescription.snp.makeConstraints { make in
            make.top.equalTo(fromLabel)
            make.leading.equalTo(kindDescription.snp.leading)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
