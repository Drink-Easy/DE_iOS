// Copyright © 2025 DRINKIG. All rights reserved

import UIKit
import CoreModule
import DesignSystem
import Then
import Network

class MyWineVintageView: UIView {
    let despText = "빈티지를 선택해 주세요"
    let lastYear = Calendar.current.component(.year, from: Date()) - 1
    public lazy var topView = NoCountDateTopView()

    public lazy var yearPicker = YearPickerView(maxYear: lastYear)
    
    public lazy var nextButton = CustomButton(title: "다음", isEnabled: false)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setWineName(_ name: String) {
        topView.setTitleLabel(title: name,
                              titleStyle: AppTextStyle.KR.subtitle1,
                              titleColor: AppColor.purple100,
                              description: despText,
                              descriptionStyle: AppTextStyle.KR.head,
                              descriptionColor: AppColor.black)
    }
    
    func setupUI() {
        backgroundColor = .clear
        addSubviews(topView, yearPicker, nextButton)
    }
    
    func setConstraints() {
        topView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.greaterThanOrEqualTo(80)
        }
        
        yearPicker.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom).offset(24)
        }
        
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(DynamicPadding.dynamicValue(40)) // 동적 기기 대응
            $0.leading.trailing.equalToSuperview()
        }
    }
}
