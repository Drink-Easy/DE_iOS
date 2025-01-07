// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit

public class CustomTextFieldView: UIView, UITextFieldDelegate {
    // MARK: - Properties
    public let descriptionLabel: UILabel
    public let textField: PaddedTextField
    let validationLabel: UILabel
    
    var text: String? {
        get {
            //필요한 연산 과정
            return textField.text
        }
        set(emailString) {
            textField.text = emailString
        }
    }
    
    // MARK: - 초기화
    public init(descriptionLabelText: String,
                textFieldPlaceholder: String,
                validationText: String) {
        // 초기화
        self.textField = PaddedTextField(padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        self.descriptionLabel = UILabel()
        self.validationLabel = UILabel()
        
        super.init(frame: .zero)
        
        setupUI(descriptionLabelText: descriptionLabelText,
                textFieldPlaceholder: textFieldPlaceholder,
                validationText: validationText)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI 세팅
    private func setupUI(descriptionLabelText: String,
                         textFieldPlaceholder: String, validationText: String) {
        
        // 설명 라벨 설정
        descriptionLabel.text = descriptionLabelText
        descriptionLabel.textColor = AppColor.black
        descriptionLabel.font = UIFont.ptdSemiBoldFont(ofSize: 18)
        
        // 텍스트 필드 설정
        textField.placeholder = textFieldPlaceholder
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = AppColor.gray10
        textField.delegate = self
        textField.layer.borderColor = AppColor.gray10?.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 8
        
        validationLabel.text = validationText
        validationLabel.textColor = AppColor.red
        validationLabel.font = UIFont.ptdMediumFont(ofSize: 12)
        validationLabel.isHidden = true
        
        let placeholderColor = AppColor.gray70
        textField.attributedPlaceholder = NSAttributedString(
            string: textFieldPlaceholder,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor ?? UIColor.systemGray]
        )
        
        // UI 추가
        addSubview(descriptionLabel)
        addSubview(textField)
        addSubview(validationLabel)
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(8)
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(48)
        }
        validationLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalTo(descriptionLabel)
        }
    }
    
    private func updateTextFieldStyle(isEditing: Bool) {
        if !isEditing {
            textField.backgroundColor = AppColor.gray10
            textField.layer.borderColor = AppColor.gray10?.cgColor
            textField.textColor = AppColor.gray70
        }
    }
    
    func updateValidationText(_ text: String, isHidden: Bool) {
        validationLabel.text = text
        validationLabel.isHidden = isHidden
    }
    
    private func showCharacterLimit() {
        validationLabel.text = "n자 이하의 닉네임을 설정해 주세요"
        validationLabel.isHidden = false
    }
    
    // MARK: - 텍스트필드 델리게이트
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        updateTextFieldStyle(isEditing: true)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        updateTextFieldStyle(isEditing: false)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        
        if let markedTextRange = textField.markedTextRange,
           let _ = textField.position(from: markedTextRange.start, offset: 0) {
            return true
        }
        
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if updatedText.count > 15 {
            showCharacterLimit()
            return false
        }
        return true
    }
}