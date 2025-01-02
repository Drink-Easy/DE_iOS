// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule

class SignUpView: UIView {
    
    // MARK: - UI Components
    let usernameField = CustomLabelTextFieldView(
        descriptionImageIcon: "person.fill",
        descriptionLabelText: "아이디",
        textFieldPlaceholder: "아이디를 입력해 주세요",
        validationText: "8~20자 이내 영소문자, 숫자의 조합"
    ).then {
        $0.textField.keyboardType = .default
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
        [usernameField, passwordField, confirmPasswordField, signupButton].forEach {
            addSubview($0)
        }
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        usernameField.snp.makeConstraints { make in
            make.top.equalTo(Constants.superViewHeight * 0.2)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
        }
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(usernameField.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
        }
        confirmPasswordField.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
        }
        signupButton.snp.makeConstraints { make in
            make.top.equalTo(Constants.superViewHeight * 0.8)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
        }
    }
}
