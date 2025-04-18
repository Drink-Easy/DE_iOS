// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule
import DesignSystem

final class LoginView: UIView {
    
    // MARK: - UI Components
    lazy var usernameField = CustomLabelTextFieldView(
        descriptionImageIcon: "person.fill",
        descriptionLabelText: "이메일",
        textFieldPlaceholder: "이메일을 입력해 주세요",
        validationText: "유효하지 않은 이메일 형식입니다"
    ).then {
        $0.textField.keyboardType = .emailAddress
    }

    lazy var passwordField = CustomLabelTextFieldView(
        descriptionImageIcon: "lock.fill",
        descriptionLabelText: "비밀번호",
        textFieldPlaceholder: "비밀번호를 입력해 주세요",
        validationText: "8~20자 이내 영문자, 숫자, 특수문자의 조합",
        isPasswordField: true
    ).then {
        $0.textField.textContentType = .newPassword
    }
    
    let joinStackView = JoinStackView()
    lazy var idSaveCheckBox = CustomCheckSquareButton(title: "아이디 저장하기")
    
    let idSearchButton = UIButton().then {
        $0.setTitle("아이디 / 비밀번호 찾기", for: .normal)
        $0.setTitleColor(AppColor.black, for: .normal)
        $0.titleLabel?.font = UIFont.pretendard(.medium, size: 14)
    }
    
    let loginButton = CustomButton(
        title: "로그인",
        titleColor: .white,
        isEnabled: false
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
        [usernameField, passwordField, idSaveCheckBox, idSearchButton, joinStackView, loginButton].forEach {
            addSubview($0)
        }
    }
    
    // MARK: - Constraints
    private func setupConstraints() {
        usernameField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(32.0))
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(32.0))
        }
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(usernameField.snp.bottom).offset(DynamicPadding.dynamicValue(32.0))
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(32.0))
        }
        idSaveCheckBox.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(DynamicPadding.dynamicValue(32.0))
            make.leading.equalToSuperview().inset(DynamicPadding.dynamicValue(32.0))
        }
//        idSearchButton.snp.makeConstraints { make in
//            make.centerY.equalTo(idSaveCheckBox)
//            make.trailing.equalToSuperview().inset(Constants.padding)
//        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(idSaveCheckBox.snp.bottom).offset(DynamicPadding.dynamicValue(32.0) * 2)
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(32.0))
        }
        joinStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
        }
    }
}
