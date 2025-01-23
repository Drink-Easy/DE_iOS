// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Then
import Network

// 보유 와인 가격 입력 뷰

class MyWinePriceView: UIView {
    public lazy var topView = NoCountDateTopView()
    public let priceTextField = CustomTextFieldView(
        descriptionLabelText: "구매 가격",
        textFieldPlaceholder: "가격을 입력해주세요",
        validationText: ""
    )
    public lazy var nextButton = CustomButton(title: "저장하기", isEnabled: false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setWineName(_ name: String) {
        self.topView.title.text = name
        self.topView.desp.text = "구매 가격을 입력해주세요"
    }
    
    func setupUI() {
        backgroundColor = .clear
        [topView, priceTextField, nextButton].forEach{ addSubview($0) }
    }
    
    func setConstraints() {
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(80)
        }
        
        priceTextField.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(40) // 동적 기기 대응
            make.leading.trailing.equalToSuperview()
        }
    }

}

