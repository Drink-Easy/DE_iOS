// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

final class ValidationManager {
    
    // MARK: - Properties
    var isUsernameValid = false
    var isEmailValid = false
    var isPasswordValid = false
    var isConfirmPasswordValid = false
    var isTermsAgreeValid = false
    
    // MARK: - Validation Methods
    func validateUsername(_ text: String?, textField: UITextField, validationLabel: UILabel) -> Bool {
        guard let username = text, !username.isEmpty else {
            showValidationError(textField, label: validationLabel, message: "이름을 입력해 주세요")
            return false
        }
        hideValidationError(textField, label: validationLabel)
        return true
    }
    
    func validateEmail(_ text: String?, textField: UITextField, validationLabel: UILabel, completion: @escaping (Bool) -> Void) {
        guard let email = text, !email.isEmpty else {
            showValidationError(textField, label: validationLabel, message: "이메일을 입력해 주세요")
            completion(false)
            return
        }
        
        // 이메일 형식 확인
        if !ValidationUtility.isValidEmail(email) {
            showValidationError(textField, label: validationLabel, message: "유효하지 않은 이메일 형식입니다")
            completion(false)
            return
        }

    }
    
    func validatePassword(_ text: String?, textField: UITextField, validationLabel: UILabel) -> Bool {
        guard let password = text, ValidationUtility.isValidPassword(password) else {
            showValidationError(textField, label: validationLabel, message: "8~20자 이내 영문자, 숫자, 특수문자의 조합")
            return false
        }
        hideValidationError(textField, label: validationLabel)
        return true
    }
    
    func validateConfirmPassword(_ password: String?, confirmPassword: String?, textField: UITextField, validationLabel: UILabel) -> Bool {
        guard let confirmPassword = confirmPassword, confirmPassword == password, !confirmPassword.isEmpty else {
            showValidationError(textField, label: validationLabel, message: "비밀번호를 다시 한 번 확인해 주세요")
            return false
        }
        hideValidationError(textField, label: validationLabel)
        return true
    }
    
    func validateTermsAgree(_ isSelected: Bool, validationLabel: UILabel) -> Bool {
        if !isSelected {
            validationLabel.isHidden = false
            return false
        }
        validationLabel.isHidden = true
        return true
    }
    
    // MARK: - UI 업데이트 메서드
    private func showValidationError(_ textField: UITextField, label: UILabel, message: String) {
        label.text = message
        label.isHidden = false
        textField.layer.borderColor = UIColor.red.cgColor
        
        
        textField.backgroundColor = UIColor.red
//        textField.leftView?.tintColor = UIColor.red
        
    }
    
    private func hideValidationError(_ textField: UITextField, label: UILabel) {
        label.isHidden = true
        textField.layer.borderColor = AppColor.purple100?.cgColor
    }
}
