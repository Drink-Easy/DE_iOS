// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

class PriceNewWineView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public lazy var wineName = UILabel().then {
        $0.text = "루이 로드레 크리스탈 2015"
        $0.textColor = UIColor(hex: "#7E13B1")
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 24)
        $0.numberOfLines = 0
    }
    
    func setWineName(_ name :String) {
        self.wineName.text = name
    }
    
    let label = UILabel().then {
        $0.text = "구매 가격을 입력해주세요"
        $0.textColor = .black
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 24)
    }

    let priceLabel = UILabel().then {
        $0.text = "구매 가격"
        $0.textColor = .black
        $0.font = .ptdSemiBoldFont(ofSize: 18)
    }
    
    let priceTextField = UITextField().then {
        $0.placeholder = "가격을 입력해주세요."
        $0.backgroundColor = AppColor.gray10
    }
    
    let nextButton = UIButton().then {
        $0.setTitle("입력 완료", for: .normal)
        $0.backgroundColor = AppColor.purple100
        $0.titleLabel?.textColor = .white
        $0.layer.cornerRadius = 10
    }
    
    func setupUI() {
        addSubview(wineName)
        wineName.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.equalToSuperview().offset(25)
        }
        addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(wineName.snp.bottom).offset(10)
            make.leading.equalTo(wineName.snp.leading)
        }
        
        addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(28)
            make.leading.equalTo(label.snp.leading).offset(3)
        }
        
        addSubview(priceTextField)
        priceTextField.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
            make.leading.equalTo(label.snp.leading)
            make.height.greaterThanOrEqualTo(48)
        }
        
        addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(28)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-42)
            make.height.greaterThanOrEqualTo(56)
        }
    }
    
}
