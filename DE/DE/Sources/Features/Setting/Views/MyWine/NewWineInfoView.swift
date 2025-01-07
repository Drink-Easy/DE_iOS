// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

class NewWineInfoView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let wineName: UILabel = {
        let w = UILabel()
        w.text = "루이 로드레 크리스탈 2015"
        w.textColor = .black
        w.textAlignment = .left
        w.numberOfLines = 0
        w.font = UIFont(name: "Pretendard-SemiBold", size: 24)
        return w
    }()
    
    private let wineImage: UIImageView = {
        let w = UIImageView()
        w.contentMode = .scaleToFill
        w.image = UIImage(named: "wine1")
        w.layer.cornerRadius = 14
        return w
    }()
    
    let descriptionView = DescriptionUIView().then {
        $0.layer.cornerRadius = 14
        $0.backgroundColor = .white
    }
    
    let buyInfo = UILabel().then {
        $0.text = "구매 정보"
        $0.textColor = .black
        $0.font = .ptdSemiBoldFont(ofSize: 18)
    }
    
    let changeLabel = UILabel().then {
        $0.text = "수정하기"
        $0.textColor = AppColor.gray70
        $0.font = .ptdMediumFont(ofSize: 12)
        $0.isUserInteractionEnabled = true
    }
    
    let infoView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    
    let vector = UIView().then {
        $0.backgroundColor = AppColor.gray30
    }
    
    let priceLabel = UILabel().then {
        $0.text = "구매 가격"
        $0.textColor = .black
        $0.font = .ptdMediumFont(ofSize: 15)
    }
    
    let wonLabel = UILabel().then {
        let price: Int
        $0.text = "\(price)원"
        $0.textColor = AppColor.gray100
        $0.font = .ptdRegularFont(ofSize: 15)
    }
    
    let dateLabel = UILabel().then {
        $0.text = "구매일"
    }
    
    let dDayLabel = UILabel().then {
        let day: Int
        $0.text = "D+\(day)"
        $0.textColor = AppColor.purple100
        $0.font = .ptdMediumFont(ofSize: 15)
    }
    
    let date = UILabel().then {
        $0.textColor = AppColor.gray100
        $0.font = .ptdRegularFont(ofSize: 15)
    }
    
    let nextButton = UIButton().then {
        $0.backgroundColor = AppColor.purple100
        $0.setTitle("시음 완료", for: .normal)
        $0.titleLabel?.textColor = .white
        $0.layer.cornerRadius = 10
    }
    
    func setupUI() {
        addSubview(wineName)
        wineName.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(25)
        }
        
        addSubview(wineImage)
        wineImage.snp.makeConstraints { make in
            make.top.equalTo(wineName.snp.bottom).offset(21)
            make.leading.equalTo(wineName.snp.leading)
        }
        
        addSubview(descriptionView)
        descriptionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(wineImage)
            make.leading.equalTo(wineImage.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        addSubview(buyInfo)
        buyInfo.snp.makeConstraints { make in
            make.leading.equalTo(wineImage.snp.leading).offset(4)
            make.top.equalTo(wineImage.snp.bottom).offset(35)
        }
        
        addSubview(changeLabel)
        changeLabel.snp.makeConstraints { make in
            make.top.equalTo(buyInfo.snp.top).offset(7)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.leading.equalTo(wineImage.snp.leading)
            make.top.equalTo(buyInfo.snp.bottom).offset(11)
            make.centerX.equalToSuperview()
        }
        
        infoView.addSubview(vector)
        vector.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        
        infoView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(13.2)
        }
        
        infoView.addSubview(wonLabel)
        wonLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.top)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        infoView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(vector.snp.bottom).offset(14)
            make.leading.equalTo(priceLabel.snp.leading)
        }
        
        infoView.addSubview(date)
        date.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.top)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(22)
            make.leading.trailing.equalTo(infoView)
        }
        
        
    }

}
