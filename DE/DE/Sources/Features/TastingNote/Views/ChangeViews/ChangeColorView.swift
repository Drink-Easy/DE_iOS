// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network

class ChangeColorView: UIView {
    
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
    
    lazy var colorStackView1 = ColorStackView(colors: ChooseColorModel().colorData.map { row in
        row.compactMap { $0 } // Optional 제거
    })
    
    let nextButton: UIButton = {
        let b = UIButton()
        b.setTitle("저장하기", for: .normal)
        b.titleLabel?.font = .ptdBoldFont(ofSize: 18)
        b.backgroundColor = UIColor(hex: "#7E13B1")
        b.layer.cornerRadius = 10
        return b
    }()
    
    
    func setupUI() {
        backgroundColor = AppColor.gray20
        
        addSubview(wineNameLabel)
        wineNameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(24)
        }
        
        addSubview(wineImage)
        wineImage.snp.makeConstraints { make in
            make.top.equalTo(wineNameLabel.snp.bottom).offset(20)
            make.leading.equalTo(wineNameLabel.snp.leading)
            make.width.height.equalTo(Constants.superViewHeight*0.1)
        }
        
        addSubview(descriptionView)
        descriptionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(wineImage)
            make.leading.equalTo(wineImage.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-24)
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
            // make.trailing.equalTo(vector.snp.trailing).offset(-62)
        }
        
        addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-42)
            make.leading.equalToSuperview().offset(28)
            make.centerX.equalToSuperview()
            make.height.equalTo(Constants.superViewHeight*0.06)
        }
    }
    
    func updateUI(wineName: String, wineSort: String, imageUrl: String, wineArea: String) {
        wineNameLabel.text = wineName
        descriptionView.kindDescription.text = wineSort
        // descriptionView.breedDescription.text
        descriptionView.fromDescription.text = wineArea
        wineImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage())
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
