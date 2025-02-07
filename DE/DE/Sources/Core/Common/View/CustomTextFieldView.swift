// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit

public class CustomTextFieldView: UIView, UITextFieldDelegate {
    // MARK: - Properties
    public let descriptionLabel: UILabel
    public let textField: PaddedTextField
    let validationLabel: UILabel
    
    public var inputLimit : Int = 15
    
    public var text: String? {
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
                validationText: String,
                limitCount : Int = 15) {
        // 초기화
        self.textField = PaddedTextField(padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        self.descriptionLabel = UILabel()
        self.validationLabel = UILabel()
        
        super.init(frame: .zero)
        
        setupUI(descriptionLabelText: descriptionLabelText,
                textFieldPlaceholder: textFieldPlaceholder,
                validationText: validationText,
                limitCount: limitCount
        )
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI 세팅
    private func setupUI(descriptionLabelText: String,
                         textFieldPlaceholder: String, validationText: String, limitCount : Int) {
        
        self.inputLimit = limitCount
        
        // 설명 라벨 설정
        descriptionLabel.text = descriptionLabelText
        descriptionLabel.textColor = AppColor.black
        descriptionLabel.font = UIFont.ptdSemiBoldFont(ofSize: 18)
        
        // 텍스트 필드 설정
        textField.placeholder = textFieldPlaceholder
        textField.borderStyle = .none
        textField.font = UIFont.ptdSemiBoldFont(ofSize: 14)
        textField.backgroundColor = AppColor.gray10
        
        textField.delegate = self
        textField.layer.borderColor = AppColor.gray10?.cgColor
        textField.layer.borderWidth = 2
        textField.layer.cornerRadius = 8
        
        textField.tintColor = AppColor.purple100
        textField.autocapitalizationType = .none //자동 대문자
        textField.spellCheckingType = .no //맞춤법 검사
        textField.autocorrectionType = .no //자동완성
        
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
            make.height.equalTo(DynamicPadding.dynamicValue(48.0))
        }
        validationLabel.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(5)
            make.leading.equalToSuperview().inset(8)
        }
    }
    
    public func updateValidationText(_ text: String, isHidden: Bool, color: UIColor?) {
        validationLabel.text = text
        validationLabel.isHidden = isHidden
        validationLabel.textColor = color
    }
    
    private func showCharacterLimit(message: String) {
        validationLabel.text = message
        validationLabel.isHidden = false
        validationLabel.textColor = AppColor.red
    }
    
    // MARK: - 텍스트필드 델리게이트
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let currentText = textField.text else { return true }
        
        // 입력 중인 텍스트 (현재 텍스트와 대체 텍스트를 합침)
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // 한글 입력 중인지 확인
        if let markedTextRange = textField.markedTextRange,
           let _ = textField.position(from: markedTextRange.start, offset: 0) {
            return true
        }
        
        //특정 글자수(기본 9) 이상 입력 받지 않음
        if updatedText.count > inputLimit {
            return false
        }
        return true
    }
}
