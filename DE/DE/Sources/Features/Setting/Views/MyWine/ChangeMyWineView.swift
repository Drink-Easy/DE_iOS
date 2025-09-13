// Copyright © 2025 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then

import CoreModule
import DesignSystem

final class ChangeMyWineView: UIView {
    let decsText = "빈티지"
    let dateTitle = "구매 일자"
    
    let scrollView = UIScrollView()
    let containerView = UIView()
    
    public lazy var topView = NoCountDateTopView()
    public lazy var yearPicker = YearPickerView()
    let thinDivider1 = DividerFactory.make()
    let thinDivider2 = DividerFactory.make()
    
    public let priceTextField = CustomTextFieldView(
        descriptionLabelText: "구매 가격",
        textFieldPlaceholder: "가격을 입력해주세요",
        validationText: ""
    ).then { t in
        t.textField.keyboardType = .numberPad
    }
    
    public lazy var dateTitleLabel = UILabel().then {
        $0.numberOfLines = 1
    }
    
    lazy var calendarContainer = UIView().then {
        $0.backgroundColor = AppColor.white
        $0.layer.cornerRadius = 10
        
        // 그림자 설정
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.04
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        $0.layer.shadowRadius = 4
        $0.layer.masksToBounds = false
    }
    
    public lazy var calender = UICalendarView().then {
        $0.timeZone = .current
        $0.backgroundColor = .clear
        $0.calendar = .current
        $0.locale = Locale(identifier: "ko_KR")
        $0.fontDesign = .rounded
        $0.wantsDateDecorations = true
        $0.tintColor = AppColor.purple100
    }
    
    public lazy var nextButton = CustomButton(title: "저장하기", isEnabled: true)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setWinePrice(_ price: Int) {
        self.priceTextField.textField.text = "\(price)"
    }
    
    func setupUI() {
        backgroundColor = AppColor.background
        AppTextStyle.KR.subtitle1.apply(to: dateTitleLabel, text: dateTitle, color: AppColor.black)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        addSubviews(scrollView, nextButton)
        calendarContainer.addSubview(calender)
        
        scrollView.addSubview(containerView)
        containerView.addSubviews(topView, yearPicker, thinDivider1, priceTextField, thinDivider2, dateTitleLabel, calendarContainer)
    }
    
    public func setTopSection(name: String) {
        topView.setTitleLabel(title: name,
                              titleStyle: AppTextStyle.KR.body1,
                              titleColor: AppColor.purple100,
                              description: decsText,
                              descriptionStyle: AppTextStyle.KR.subtitle1,
                              descriptionColor: AppColor.black)
    }
    
    func setConstraints() {
        nextButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(42)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(nextButton.snp.top).inset(-24)
        }
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        yearPicker.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(topView.snp.bottom).offset(20)
        }
        
        thinDivider1.snp.makeConstraints {
            $0.top.equalTo(yearPicker.snp.bottom).offset(24)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
        }
        
        priceTextField.snp.makeConstraints {
            $0.top.equalTo(thinDivider1.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }
        
        thinDivider2.snp.makeConstraints {
            $0.top.equalTo(priceTextField.snp.bottom).offset(24)
            $0.height.equalTo(1)
            $0.leading.trailing.equalToSuperview()
        }
        
        dateTitleLabel.snp.makeConstraints {
            $0.top.equalTo(thinDivider2.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }
        
        calender.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
        
        calendarContainer.snp.makeConstraints {
            $0.top.equalTo(dateTitleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(4)
            $0.height.equalTo(calendarContainer.snp.width).multipliedBy(1.15)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
}
