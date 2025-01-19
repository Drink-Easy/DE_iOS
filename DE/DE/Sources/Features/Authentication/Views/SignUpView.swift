// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule

class SignUpView: UIView {
    
    // MARK: - UI Components
    lazy var usernameField = CustomLabelTextFieldView(
        descriptionImageIcon: "person.fill",
        descriptionLabelText: "이메일",
        textFieldPlaceholder: "이메일을 입력해 주세요",
        validationText: "유효하지 않은 이메일 형식입니다"
    ).then {
        $0.textField.keyboardType = .emailAddress
    }
    
    let checkEmailButton = UIButton().then {
        $0.setTitle("중복 확인", for: .normal)
        $0.setTitleColor(AppColor.gray70, for: .normal)
        $0.titleLabel?.font = UIFont.ptdSemiBoldFont(ofSize: 12)
    }

    let passwordField = CustomLabelTextFieldView(
        descriptionImageIcon: "lock.fill",
        descriptionLabelText: "비밀번호",
        textFieldPlaceholder: "비밀번호를 입력해 주세요",
        validationText: "8~20자 이내 영문자, 숫자, 특수문자의 조합",
        isPasswordField: true
    ).then {
        $0.textField.textContentType = .newPassword
    }

    let confirmPasswordField = CustomLabelTextFieldView(
        descriptionImageIcon: "lock.fill",
        descriptionLabelText: "비밀번호 재입력",
        textFieldPlaceholder: "비밀번호를 다시 입력해 주세요",
        validationText: "다시 확인해 주세요",
        isPasswordField: true
    ).then {
        $0.textField.textContentType = .newPassword
    }

    let signupButton = CustomButton(
        title: "회원가입",
        titleColor: .white,
        isEnabled: false
    ).then {
        $0.isEnabled = false
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColor.bgGray
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        [usernameField, checkEmailButton, passwordField, confirmPasswordField, signupButton].forEach {
            addSubview($0)
        }
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        usernameField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(32.0))
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(32.0))
        }
        checkEmailButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(32.0))
            make.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(32.0))
        }
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(usernameField.snp.bottom).offset(DynamicPadding.dynamicValue(32.0))
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(32.0))
        }
        confirmPasswordField.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(DynamicPadding.dynamicValue(32.0))
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(32.0))
        }
        signupButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordField.snp.bottom).offset(DynamicPadding.dynamicValue(32.0) * 2)
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(32.0))
        }
    }
}
