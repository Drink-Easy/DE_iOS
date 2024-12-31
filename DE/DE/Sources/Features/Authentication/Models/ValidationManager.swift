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
    func validateUsername(_ view: CustomLabelTextFieldView) -> Bool {
        guard let username = view.text, !username.isEmpty else {
            showValidationError(view, message: "이름을 입력해 주세요")
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
        if !isValidEmail(email) {
            showValidationError(view, message: "유효하지 않은 이메일 형식입니다")
            return false
        }
        hideValidationError(view)
        return true
    }
    
    func validatePassword(_ view: CustomLabelTextFieldView) -> Bool {
        guard let password = view.text, isValidPassword(password) else {
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
    
    // MARK: - 정규식 함수
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-=?.,<>]).{8,15}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
    
    // MARK: - UI 업데이트 메서드
    private func showValidationError(_ view: CustomLabelTextFieldView, message: String) {
        view.updateValidationText(message, isHidden: false)
        view.textField.layer.borderColor = AppColor.red?.cgColor
        view.textField.backgroundColor = AppColor.red?.withAlphaComponent(0.1)
        view.iconImageView.tintColor = AppColor.red
    }
    
    private func hideValidationError(_ view: CustomLabelTextFieldView) {
        view.updateValidationText("", isHidden: true)
        view.textField.layer.borderColor = AppColor.purple100?.cgColor
        view.textField.backgroundColor = AppColor.purple10
        view.iconImageView.tintColor = AppColor.purple100
    }
}
