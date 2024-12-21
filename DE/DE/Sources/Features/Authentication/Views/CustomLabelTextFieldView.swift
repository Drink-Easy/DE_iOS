// Copyright © 2024 RT4. All rights reserved

import UIKit
import CoreModule

public class CustomLabelTextFieldView: UIView, UITextFieldDelegate {
    let descriptionLabel: UILabel
    let textField: PaddedTextField
    let validationLabel: UILabel
    let imageView: UIImageView
    
    var text: String? {
        return textField.text
    }
    
    public init(descriptionImageIcon: String, descriptionLabelText: String, textFieldPlaceholder: String, validationText: String) {
        self.textField = PaddedTextField(padding: UIEdgeInsets(top: 0, left: 48, bottom: 0, right: 16))
        self.validationLabel = UILabel()
        self.descriptionLabel = UILabel()
        self.imageView = UIImageView()
        
        super.init(frame: .zero)
        
        imageView.image = UIImage(systemName: descriptionImageIcon)?.withRenderingMode(.alwaysTemplate)
                imageView.contentMode = .scaleAspectFit
                imageView.tintColor = AppColor.gray60 // 초기 색상 설정
        
        descriptionLabel.text = descriptionLabelText
        descriptionLabel.textColor = AppColor.black
        descriptionLabel.font = UIFont.ptdSemiBoldFont(ofSize: 14)
        
        textField.placeholder = textFieldPlaceholder
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = AppColor.gray30
        textField.delegate = self
        
        textField.layer.borderColor = AppColor.gray30?.cgColor
        textField.layer.borderWidth = 2  // 원하 는 테두리 두께로 설정
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
        textField.addSubview(imageView)
        addSubview(validationLabel)
        addSubview(descriptionLabel)
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16) // 원하는 leading 간격 설정
            make.centerY.equalToSuperview() // 수직 가운데 정렬
            make.width.height.equalTo(20) // 이미지 크기 설정
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
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateValidationText(_ text: String, isHidden: Bool) {
        validationLabel.text = text
        validationLabel.isHidden = isHidden
    }

    private func updateTextFieldStyle(isEditing: Bool) {
        if isEditing {
            textField.backgroundColor = AppColor.purple10
            textField.layer.borderColor = AppColor.purple100?.cgColor
            imageView.tintColor = AppColor.purple100
        } else {
            textField.backgroundColor = AppColor.gray30
            textField.layer.borderColor = AppColor.gray30?.cgColor
            imageView.tintColor = AppColor.gray60
        }
        
    }
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        updateTextFieldStyle(isEditing: true)
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        updateTextFieldStyle(isEditing: false)
    }
    
}
