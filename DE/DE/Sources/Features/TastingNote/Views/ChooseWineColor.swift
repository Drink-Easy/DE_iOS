//
//  ChooseWineColor.swift
//  Drink-EG
//
//  Created by 이수현 on 11/11/24.
//

import UIKit

class ChooseWineColor: UIView {

    let wineNameLabel: UILabel = {
        let w = UILabel()
        w.text = "루이 로드레 크리스탈 2015"
        w.font = .ptdSemiBoldFont(ofSize: 24)
        w.textColor = .black
        w.textAlignment = .center
        return w
    }()
    
    let wineImage: UIImageView = {
        let w = UIImageView()
        w.layer.cornerRadius = 14
        w.contentMode = .scaleAspectFit
        w.image = UIImage(named: "Rodre")
        return w
    }()
    
    let descriptionView: DescriptionUIView = {
        let d = DescriptionUIView()
        d.layer.cornerRadius = 14
        d.backgroundColor = .white
        
        return d
    }()
    
    let colorLabel: UILabel = {
        let c = UILabel()
        c.text = "Color"
        c.textColor = .black
        c.font = .ptdSemiBoldFont(ofSize: 20)
        c.textAlignment = .center
        return c
    }()
    
    let colorLabelKorean: UILabel = {
        let c = UILabel()
        c.text = "색상"
        c.textColor = UIColor(hex: "919191")
        c.font = .ptdRegularFont(ofSize: 14)
        c.textAlignment = .center
        return c
    }()
    
    let vector: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#B06FCD")
        return v
    }()
    
    let colorStackView1 = ColorStackView()
    let colorStackView2 = ColorStackView()
    let colorStackView3 = ColorStackView()
    let colorStackView4 = ColorStackView()
    
    let nextButton: UIButton = {
        let b = UIButton()
        b.setTitle("다음", for: .normal)
        b.titleLabel?.font = .ptdBoldFont(ofSize: 18)
        b.backgroundColor = UIColor(hex: "#7E13B1")
        b.layer.cornerRadius = 10
        return b
    }()
    
    
    func setupUI() {
        addSubview(wineNameLabel)
        wineNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(110)
            make.leading.equalToSuperview().offset(24)
        }
        
        addSubview(wineImage)
        wineImage.snp.makeConstraints { make in
            make.top.equalTo(wineNameLabel.snp.bottom).offset(20)
            make.leading.equalTo(wineNameLabel.snp.leading)
            make.width.height.equalTo(100)
        }
        
        addSubview(descriptionView)
        descriptionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(wineImage)
            make.leading.equalTo(wineImage.snp.trailing).offset(8)
        }
        
        addSubview(colorLabel)
        colorLabel.snp.makeConstraints { make in
            make.top.equalTo(wineImage.snp.bottom).offset(57)
            make.leading.equalTo(wineImage.snp.leading)
        }
        
        addSubview(colorLabelKorean)
        colorLabelKorean.snp.makeConstraints { make in
            make.top.equalTo(colorLabel.snp.top).offset(4)
            make.leading.equalTo(colorLabel.snp.trailing).offset(8)
        }
        
        
        addSubview(vector)
        vector.snp.makeConstraints { make in
            make.top.equalTo(colorLabel.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.leading.equalTo(24)
            make.height.equalTo(1)
        }
        
        addSubview(colorStackView1)
        colorStackView1.snp.makeConstraints { make in
            make.top.equalTo(vector.snp.bottom).offset(24)
            make.leading.equalTo(vector.snp.leading)
            make.trailing.equalTo(vector.snp.trailing).offset(-62)
        }
        
        addSubview(colorStackView2)
        colorStackView2.snp.makeConstraints { make in
            make.top.equalTo(colorStackView1.snp.bottom).offset(15)
            make.leading.equalTo(colorStackView1)
        }
        
        addSubview(colorStackView3)
        colorStackView3.snp.makeConstraints { make in
            make.top.equalTo(colorStackView2.snp.bottom).offset(15)
            make.leading.equalTo(colorStackView2)
        }
        
        addSubview(colorStackView4)
        colorStackView4.snp.makeConstraints { make in
            make.top.equalTo(colorStackView3.snp.bottom).offset(15)
            make.leading.equalTo(colorStackView3)
        }
        
        addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(colorStackView4.snp.bottom).offset(143)
            make.leading.equalTo(colorStackView4.snp.leading).offset(-3)
            make.centerX.equalToSuperview()
            make.height.equalTo(56)
        }
        
        
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
