// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import DesignSystem

public class CustomLabelTextFieldView: UIView, UITextFieldDelegate {
    // MARK: - Properties
    let descriptionLabel: UILabel
    let textField: PaddedTextField
    let validationLabel: UILabel
    let iconImageView: UIImageView
    let toggleButton: UIButton? // 패스워드 보기 버튼

    var text: String? {
        get {
            //필요한 연산 과정
            return textField.text
        }
        set(emailString) {
            textField.text = emailString
        }
    }
    
    private var isPasswordField: Bool = false
    private var isPasswordVisible: Bool = false
    
    // MARK: - 초기화
    public init(descriptionImageIcon: String,
                descriptionLabelText: String,
                textFieldPlaceholder: String,
                validationText: String,
                isPasswordField: Bool = false
    ) {
        // 초기화
        self.textField = PaddedTextField(padding: UIEdgeInsets(top: 0, left: 48, bottom: 0, right: 16))
        self.validationLabel = UILabel()
        self.descriptionLabel = UILabel()
        self.iconImageView = UIImageView()
        self.isPasswordField = isPasswordField
        
        // 패스워드 필드일 경우 토글 버튼 추가
        self.toggleButton = isPasswordField ? UIButton(type: .custom) : nil
        
        super.init(frame: .zero)
        
        setupUI(descriptionImageIcon: descriptionImageIcon,
                descriptionLabelText: descriptionLabelText,
                textFieldPlaceholder: textFieldPlaceholder,
                validationText: validationText)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI 세팅
    private func setupUI(descriptionImageIcon: String,
                         descriptionLabelText: String,
                         textFieldPlaceholder: String,
                         validationText: String) {
        // 아이콘 설정
        iconImageView.image = UIImage(systemName: descriptionImageIcon)?.withRenderingMode(.alwaysTemplate)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = AppColor.gray50
        
        // 설명 라벨 설정
        descriptionLabel.text = descriptionLabelText
        descriptionLabel.textColor = AppColor.black
        descriptionLabel.font = UIFont.pretendard(.semiBold, size: 14)
        
        // 텍스트 필드 설정
        textField.placeholder = textFieldPlaceholder
        textField.borderStyle = .none
        textField.font = UIFont.pretendard(.medium, size: 14)
        textField.backgroundColor = AppColor.gray10
        textField.delegate = self
        textField.layer.borderColor = AppColor.gray10.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 10
        textField.isSecureTextEntry = isPasswordField // 비밀번호 필드 여부에 따라 처리
        
        textField.tintColor = AppColor.purple100
        
        textField.autocapitalizationType = .none //자동 대문자
        textField.spellCheckingType = .no //맞춤법 검사
        textField.autocorrectionType = .no //자동완성
        
        let placeholderColor = AppColor.gray70
        textField.attributedPlaceholder = NSAttributedString(
            string: textFieldPlaceholder,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
        )
        
        // 유효성 라벨 설정
        validationLabel.text = validationText
        validationLabel.textColor = AppColor.red
        validationLabel.font = UIFont.pretendard(.medium, size: 12)
        validationLabel.isHidden = true
        
        // UI 추가
        addSubview(descriptionLabel)
        addSubview(textField)
        addSubview(validationLabel)
        textField.addSubview(iconImageView)
        
        // 패스워드 보기 버튼 설정
        if let toggleButton = toggleButton {
            addSubview(toggleButton)
            toggleButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            toggleButton.tintColor = AppColor.gray50
            toggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
            
            toggleButton.snp.makeConstraints { make in
                make.trailing.equalTo(textField.snp.trailing).inset(16)
                make.centerY.equalTo(textField)
                make.width.height.equalTo(24)
            }
        }
        
        // 레이아웃 설정
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalTo(textField)
            make.width.height.equalTo(20)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
        validationLabel.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(5)
            make.leading.equalTo(descriptionLabel.snp.leading)
        }
    }
    
    // MARK: - 비밀번호 표시 토글
    @objc private func togglePasswordVisibility() {
        guard let toggleButton = toggleButton else { return }
        
        isPasswordVisible.toggle() // 상태 변경
        textField.isSecureTextEntry = !isPasswordVisible
        
        let imageName = isPasswordVisible ? "eye" : "eye.slash"
        toggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    // MARK: - 유효성 검사 업데이트
    func updateValidationText(_ text: String, isHidden: Bool, color: UIColor?) {
        validationLabel.text = text
        validationLabel.isHidden = isHidden
        validationLabel.textColor = color
    }
}
