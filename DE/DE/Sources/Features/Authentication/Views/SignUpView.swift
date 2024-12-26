// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import CoreModule

class SignUpView: UIView {
    
    // MARK: - UI Components
    let emailField: CustomLabelTextFieldView = {
        let field = CustomLabelTextFieldView(descriptionImageIcon: "person.fill", descriptionLabelText: "이메일", textFieldPlaceholder: "이메일을 입력해 주세요", validationText: "이메일 형식이 올바르지 않습니다")
        field.textField.keyboardType = .emailAddress
        return field
    }()
    
    let passwordField: CustomLabelTextFieldView = {
        let field = CustomLabelTextFieldView(descriptionImageIcon: "lock.fill", descriptionLabelText: "비밀번호", textFieldPlaceholder: "비밀번호를 입력해 주세요", validationText: "8~20자 이내 영문자, 숫자, 특수문자의 조합", isPasswordField: true)
        field.textField.textContentType = .newPassword
        return field
    }()
    
    let confirmPasswordField: CustomLabelTextFieldView = {
        let field = CustomLabelTextFieldView(descriptionImageIcon: "lock.fill", descriptionLabelText: "비밀번호 재입력", textFieldPlaceholder: "비밀번호를 다시 입력해 주세요", validationText: "다시 확인해 주세요", isPasswordField: true)
        field.textField.textContentType = .newPassword
        return field
    }()
    
    let signupButton: CustomButton = {
        let button = CustomButton(title: "회원가입", titleColor: .white, backgroundColor: AppColor.gray80!)
        button.isEnabled = false
        return button
    }()
    
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
        [emailField, passwordField, confirmPasswordField, signupButton].forEach {
            addSubview($0)
        }
    }
    
    // MARK: - Setup Constraints
    private func setupConstraints() {
        emailField.snp.makeConstraints { make in
            make.top.equalTo(Constants.superViewHeight * 0.2)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
        }
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(32)
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
