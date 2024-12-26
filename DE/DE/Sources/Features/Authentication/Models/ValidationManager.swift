// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

//final class ValidationManager {
//    
//    // MARK: - Properties
//    var isUsernameValid = false
//    var isEmailValid = false
//    var isPasswordValid = false
//    var isConfirmPasswordValid = false
//    var isTermsAgreeValid = false
//    
//    // MARK: - Validation Methods
//    func validateUsername(_ text: String?, textField: UITextField, validationLabel: UILabel) -> Bool {
//        guard let username = text, !username.isEmpty else {
//            showValidationError(textField, label: validationLabel, message: "이름을 입력해 주세요")
//            return false
//        }
//        hideValidationError(textField, label: validationLabel)
//        return true
//    }
//    
//    func validateEmail(_ text: String?, textField: UITextField, validationLabel: UILabel, completion: @escaping (Bool) -> Void) {
//        guard let email = text, !email.isEmpty else {
//            showValidationError(textField, label: validationLabel, message: "이메일을 입력해 주세요")
//            completion(false)
//            return
//        }
//        
//        // 이메일 형식 확인
//        if !ValidationUtility.isValidEmail(email) {
//            showValidationError(textField, label: validationLabel, message: "유효하지 않은 이메일 형식입니다")
//            completion(false)
//            return
//        }
//
//    }
//    
//    func validatePassword(_ text: String?, textField: UITextField, validationLabel: UILabel) -> Bool {
//        guard let password = text, ValidationUtility.isValidPassword(password) else {
//            showValidationError(textField, label: validationLabel, message: "8~20자 이내 영문자, 숫자, 특수문자의 조합")
//            return false
//        }
//        hideValidationError(textField, label: validationLabel)
//        return true
//    }
//    
//    func validateConfirmPassword(_ password: String?, confirmPassword: String?, textField: UITextField, validationLabel: UILabel) -> Bool {
//        guard let confirmPassword = confirmPassword, confirmPassword == password, !confirmPassword.isEmpty else {
//            showValidationError(textField, label: validationLabel, message: "비밀번호를 다시 한 번 확인해 주세요")
//            return false
//        }
//        hideValidationError(textField, label: validationLabel)
//        return true
//    }
//    
//    func validateTermsAgree(_ isSelected: Bool, validationLabel: UILabel) -> Bool {
//        if !isSelected {
//            validationLabel.isHidden = false
//            return false
//        }
//        validationLabel.isHidden = true
//        return true
//    }
//    
//    // MARK: - UI 업데이트 메서드
//    private func updateLeftViewColor(_ textField: UITextField, color: UIColor) {
//        if let leftView = textField.leftView,
//           let imageView = leftView.subviews.first as? UIImageView {
//            imageView.tintColor = color // LeftView 색상 변경
//        }
//    }
//    
//    private func showValidationError(_ textField: UITextField, label: UILabel, message: String) {
//        label.text = message
//        label.isHidden = false
//        textField.layer.borderColor = UIColor.red.cgColor
//        textField.backgroundColor = UIColor.red.withAlphaComponent(0.1) // 약간의 빨간색 배경 적용
//
//        // LeftView 색상 빨간색으로 변경
//        updateLeftViewColor(textField, color: .red)
//    }
//
//    private func hideValidationError(_ textField: UITextField, label: UILabel) {
//        label.isHidden = true
//        textField.layer.borderColor = AppColor.purple100?.cgColor
//        textField.backgroundColor = AppColor.gray30
//
//        // LeftView 색상 원래 색상으로 복구
//        updateLeftViewColor(textField, color: AppColor.gray60!)
//    }
//    
//}

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
    func validateUsername(_ view: CustomLabelTextFieldView) -> Bool {
        guard let username = view.text, !username.isEmpty else {
            showValidationError(view, message: "이름을 입력해 주세요")
            return false
        }
        hideValidationError(view)
        return true
    }
    
    func validateEmail(_ view: CustomLabelTextFieldView) -> Bool {
        guard let email = view.text, !email.isEmpty else {
            showValidationError(view, message: "이메일을 입력해 주세요")
            return false
        }
        
        // 이메일 형식 확인
        if !ValidationUtility.isValidEmail(email) {
            showValidationError(view, message: "유효하지 않은 이메일 형식입니다")
            return false
        }
        hideValidationError(view)
        return true
    }
    
    func validatePassword(_ view: CustomLabelTextFieldView) -> Bool {
        guard let password = view.text, ValidationUtility.isValidPassword(password) else {
            showValidationError(view, message: "8~20자 이내 영문자, 숫자, 특수문자의 조합")
            return false
        }
        hideValidationError(view)
        return true
    }
    
    func validateConfirmPassword(_ view: CustomLabelTextFieldView, password: String?) -> Bool {
        guard let confirmPassword = view.text, confirmPassword == password, !confirmPassword.isEmpty else {
            showValidationError(view, message: "비밀번호를 다시 한 번 확인해 주세요")
            return false
        }
        hideValidationError(view)
        return true
    }
    
    // MARK: - UI 업데이트 메서드
    private func showValidationError(_ view: CustomLabelTextFieldView, message: String) {
        view.updateValidationText(message, isHidden: false)
        view.textField.layer.borderColor = UIColor.red.cgColor
        view.textField.backgroundColor = UIColor.red.withAlphaComponent(0.1)
        view.iconImageView.tintColor = .red
    }
    
    private func hideValidationError(_ view: CustomLabelTextFieldView) {
        view.updateValidationText("", isHidden: true)
        view.textField.layer.borderColor = AppColor.purple100?.cgColor
        view.textField.backgroundColor = AppColor.purple10
        view.iconImageView.tintColor = AppColor.purple100
    }
}
