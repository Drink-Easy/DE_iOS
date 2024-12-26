// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Then
import SnapKit

final class LoginView: UIView {
    
    // MARK: - UI Components
    lazy var emailField: CustomLabelTextFieldView = {
        let field = CustomLabelTextFieldView(
            descriptionImageIcon: "person.fill",
            descriptionLabelText: "이메일",
            textFieldPlaceholder: "이메일을 입력해 주세요",
            validationText: "사용할 수 없는 이메일입니다"
        )
        field.textField.keyboardType = .emailAddress
        return field
    }()
    
    lazy var passwordField: CustomLabelTextFieldView = {
        let field = CustomLabelTextFieldView(
            descriptionImageIcon: "lock.fill",
            descriptionLabelText: "비밀번호",
            textFieldPlaceholder: "비밀번호를 입력해 주세요",
            validationText: "8~20자 이내 영문자, 숫자, 특수문자의 조합",
            isPasswordField: true
        )
        field.textField.textContentType = .newPassword
        return field
    }()
    
    let joinStackView = JoinStackView()
    lazy var emailSaveCheckBox = CustomCheckSquareButton(title: "아이디 저장하기")
    
    let idSearchButton = UIButton().then {
        $0.setTitle("아이디 / 비밀번호 찾기", for: .normal)
        $0.setTitleColor(UIColor(hex: "#191919"), for: .normal)
        $0.titleLabel?.font = UIFont.ptdMediumFont(ofSize: 14)
    }
    
    let loginButton = CustomButton(
        title: "로그인",
        titleColor: .white,
        backgroundColor: AppColor.purple100!
    )
    
    // MARK: - 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI 설정
    private func setupUI() {
        [emailField, passwordField, emailSaveCheckBox, idSearchButton, joinStackView, loginButton].forEach {
            addSubview($0)
        }
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        emailField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.superViewHeight * 0.2)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
        }
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
        }
        emailSaveCheckBox.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(Constants.padding)
        }
        idSearchButton.snp.makeConstraints { make in
            make.centerY.equalTo(emailSaveCheckBox)
            make.trailing.equalToSuperview().inset(Constants.padding)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(idSearchButton.snp.bottom).offset(64)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
        }
        joinStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
        }
    }
}
