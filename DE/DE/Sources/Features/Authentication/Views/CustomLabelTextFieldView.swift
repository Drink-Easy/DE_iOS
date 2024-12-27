// Copyright © 2024 RT4. All rights reserved

import UIKit
import CoreModule

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
        iconImageView.tintColor = AppColor.gray60
        
        // 설명 라벨 설정
        descriptionLabel.text = descriptionLabelText
        descriptionLabel.textColor = AppColor.black
        descriptionLabel.font = UIFont.ptdSemiBoldFont(ofSize: 14)
        
        // 텍스트 필드 설정
        textField.placeholder = textFieldPlaceholder
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = AppColor.gray30
        textField.delegate = self
        textField.layer.borderColor = AppColor.gray30?.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 15
        textField.isSecureTextEntry = isPasswordField // 비밀번호 필드 여부에 따라 처리
        
        let placeholderColor = AppColor.gray80
        textField.attributedPlaceholder = NSAttributedString(
            string: textFieldPlaceholder,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor ?? UIColor.systemGray]
        )
        
        // 유효성 라벨 설정
        validationLabel.text = validationText
        validationLabel.textColor = .red
        validationLabel.font = UIFont.systemFont(ofSize: 12)
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
            toggleButton.tintColor = AppColor.gray60
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
        validationLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalTo(descriptionLabel)
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(60)
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
    func updateValidationText(_ text: String, isHidden: Bool) {
        validationLabel.text = text
        validationLabel.isHidden = isHidden
    }
    
    private func updateTextFieldStyle(isEditing: Bool) {
        if isEditing {
            textField.backgroundColor = AppColor.purple10
            textField.layer.borderColor = AppColor.purple100?.cgColor
            iconImageView.tintColor = AppColor.purple100
        } else {
            textField.backgroundColor = AppColor.gray30
            textField.layer.borderColor = AppColor.gray30?.cgColor
            iconImageView.tintColor = AppColor.gray60
            validationLabel.isHidden = true
        }
    }
    
    // MARK: - 텍스트필드 델리게이트
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        updateTextFieldStyle(isEditing: true)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        updateTextFieldStyle(isEditing: false)
    }
}
