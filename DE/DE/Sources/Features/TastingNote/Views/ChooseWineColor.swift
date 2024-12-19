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
    
    let colorStackView = ColorStackView()
    
    let tastingNoteLabel: UILabel = {
        let t = UILabel()
        t.text = "Tasting Note"
        t.textColor = .black
        t.font = .ptdSemiBoldFont(ofSize: 20)
        t.textAlignment = .center
        return t
    }()
    
    let tastingLabelKorean: UILabel = {
        let c = UILabel()
        c.text = "테이스팅 노트"
        c.textColor = UIColor(hex: "919191")
        c.font = .ptdRegularFont(ofSize: 14)
        c.textAlignment = .center
        return c
    }()
    
    let vector2: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#B06FCD")
        return v
    }()
    
    let aromaLabel: UILabel = {
        let a = UILabel()
        a.text = "Aroma"
        a.textColor = .black
        a.font = .ptdSemiBoldFont(ofSize: 18)
        a.textAlignment = .center
        return a
    }()
    
    let aromaLabelKorean: UILabel = {
        let c = UILabel()
        c.text = "아로마"
        c.textColor = UIColor(hex: "919191")
        c.font = .ptdRegularFont(ofSize: 14)
        c.textAlignment = .center
        return c
    }()
    
    let tasteLabel: UILabel = {
        let a = UILabel()
        a.text = "Taste"
        a.textColor = .black
        a.font = .ptdSemiBoldFont(ofSize: 18)
        a.textAlignment = .center
        return a
    }()
    
    let tasteLabelKorean: UILabel = {
        let c = UILabel()
        c.text = "맛"
        c.textColor = UIColor(hex: "919191")
        c.font = .ptdRegularFont(ofSize: 14)
        c.textAlignment = .center
        return c
    }()
    
    let finishLabel: UILabel = {
        let a = UILabel()
        a.text = "Finish"
        a.textColor = .black
        a.font = .ptdSemiBoldFont(ofSize: 18)
        a.textAlignment = .center
        return a
    }()
    
    let finishLabelKorean: UILabel = {
        let c = UILabel()
        c.text = "여운"
        c.textColor = UIColor(hex: "919191")
        c.font = .ptdRegularFont(ofSize: 14)
        c.textAlignment = .center
        return c
    }()
    
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
        }
        
        addSubview(descriptionView)
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(wineImage)
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
        
        addSubview(colorStackView)
        colorStackView.snp.makeConstraints { make in
            make.top.equalTo(vector.snp.bottom).offset(24)
            make.leading.equalTo(vector.snp.leading)
            make.trailing.equalTo(vector.snp.trailing).offset(-62)
        }
        
        addSubview(tastingNoteLabel)
        tastingNoteLabel.snp.makeConstraints { make in
            make.top.equalTo(colorStackView.snp.bottom).offset(50)
            make.leading.equalTo(colorStackView.snp.leading)
        }
        
        addSubview(tastingLabelKorean)
        tastingLabelKorean.snp.makeConstraints { make in
            make.top.equalTo(tastingNoteLabel.snp.top).offset(4)
            make.leading.equalTo(tastingNoteLabel.snp.trailing).offset(8)
        }
        
        addSubview(vector2)
        vector2.snp.makeConstraints { make in
            make.top.equalTo(tastingNoteLabel.snp.bottom).offset(6)
            make.leading.equalTo(tastingNoteLabel.snp.leading)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        
        addSubview(aromaLabel)
        aromaLabel.snp.makeConstraints { make in
            make.top.equalTo(vector2.snp.bottom).offset(24)
            make.leading.equalTo(vector2.snp.leading).offset(1)
        }
        
        addSubview(aromaLabelKorean)
        aromaLabelKorean.snp.makeConstraints { make in
            make.top.equalTo(aromaLabel.snp.top).offset(4)
            make.leading.equalTo(aromaLabel.snp.trailing).offset(8)
        }
        
        addSubview(tasteLabel)
        tasteLabel.snp.makeConstraints { make in
            make.top.equalTo(aromaLabel.snp.bottom).offset(50)
            make.leading.equalTo(aromaLabel.snp.leading)
        }
        
        addSubview(tasteLabelKorean)
        tasteLabelKorean.snp.makeConstraints { make in
            make.top.equalTo(tasteLabel.snp.top).offset(4)
            make.leading.equalTo(tasteLabel.snp.trailing).offset(8)
        }
        
        addSubview(finishLabel)
        finishLabel.snp.makeConstraints { make in
            make.top.equalTo(tasteLabel.snp.bottom).offset(50)
            make.leading.equalTo(tasteLabel.snp.leading)
        }
        
        addSubview(finishLabelKorean)
        finishLabelKorean.snp.makeConstraints { make in
            make.top.equalTo(finishLabel.snp.top).offset(4)
            make.leading.equalTo(finishLabel.snp.trailing).offset(8)
        }
        
        addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(finishLabel.snp.bottom).offset(50)
            make.leading.equalTo(finishLabel.snp.leading).offset(3)
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
