// Copyright © 2024 RT4. All rights reserved

import UIKit
import CoreModule

public class CustomLabelTextFieldView: UIView {
    let descriptionLabel: UILabel
    let textField: PaddedTextField
    let validationLabel: UILabel
    
    var text: String? {
        return textField.text
    }
    
    public init(descriptionLabelText: String, textFieldPlaceholder: String, validationText: String) {
        self.textField = PaddedTextField(padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        self.validationLabel = UILabel()
        self.descriptionLabel = UILabel()
        
        super.init(frame: .zero)
        
        descriptionLabel.text = descriptionLabelText
        descriptionLabel.textColor = AppColor.black
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        textField.placeholder = textFieldPlaceholder
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = AppColor.gray40
        
        textField.layer.borderColor = AppColor.gray40?.cgColor
        textField.layer.borderWidth = 1.0  // 원하 는 테두리 두께로 설정
        textField.layer.cornerRadius = 15
        
        let placeholderColor = AppColor.gray80
        textField.attributedPlaceholder = NSAttributedString(
            string: textFieldPlaceholder,
            attributes: [NSAttributedString.Key.foregroundColor: placeholderColor ?? UIColor.systemGray]
        )
        
        validationLabel.text = validationText
        validationLabel.textColor = AppColor.black
        validationLabel.font = UIFont.systemFont(ofSize: 12)
        validationLabel.isHidden = true // Initially hidden
        
        addSubview(textField)
        addSubview(validationLabel)
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        validationLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.centerY.equalTo(descriptionLabel)
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateValidationText(_ text: String, isHidden: Bool) {
        validationLabel.text = text
        validationLabel.isHidden = isHidden
    }
    
    private func updateTextFieldStyle(isEditing: Bool) {
        if isEditing {
            textField.backgroundColor = AppColor.purple100
            textField.layer.borderColor = AppColor.purple10?.cgColor
        } else {
            textField.backgroundColor = AppColor.gray40
            textField.layer.borderColor = AppColor.gray40?.cgColor
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            updateTextFieldStyle(isEditing: true)
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            updateTextFieldStyle(isEditing: false)
        }
    }
}
