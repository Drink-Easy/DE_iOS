// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import CoreModule
import Network

final class ValidationManager {
    
    // MARK: - Properties
    private let networkService = AuthService()
    
    var isUsernameValid = false
    var isPasswordValid = false
    var isConfirmPasswordValid = false
    var isTermsAgreeValid = false
    var isEmailDuplicate = true //true 이면 이메일 중복 상태
    
    // MARK: - Validation Methods
    
    func validateUsername(_ view: CustomLabelTextFieldView) -> Bool {
        // 이메일이 비어있는지 확인
        guard let username = view.text, !username.isEmpty else {
            showValidationError(view, message: "이메일을 입력해 주세요")
            return false
        }
        
        // 이메일 형식 확인
        guard isValidUserName(username) else {
            showValidationError(view, message: "이메일 형식을 확인해 주세요")
            return false
        }
        
        // 이메일 중복 확인
        guard !isEmailDuplicate else {
            showValidationError(view, message: "이메일 중복 확인이 필요합니다")
            return true
        }
        
        // 모든 검증 통과
        hideValidationError(view, message: "")
        return true
    }
    
    func checkEmailDuplicate(email: String, view: CustomLabelTextFieldView) {
        let emailCheckDTO = networkService.makeEmailCheckDTO(emailString: email)
        
        networkService.checkEmail(data: emailCheckDTO) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if response {
                    self.showValidationError(view, message: "이미 사용 중인 이메일입니다.")
                    self.isEmailDuplicate = true
                } else {
                    self.hideValidationError(view, message: "사용 가능한 이메일입니다.")
                    self.isEmailDuplicate = false
                }
            case .failure(let error):
                print("네트워크 요청 실패: \(error)")
                self.showValidationError(view, message: "이메일 확인 중 오류가 발생했습니다.")
            }
        }
    }
    
    func validatePassword(_ view: CustomLabelTextFieldView) -> Bool {
        guard let password = view.text, isValidPassword(password) else {
            showValidationError(view, message: "8~20자 이내 영문자, 숫자, 특수문자의 조합")
            return false
        }
        hideValidationError(view, message: "")
        return true
    }
    
    func validateConfirmPassword(_ view: CustomLabelTextFieldView, password: String?) -> Bool {
        guard let confirmPassword = view.text, isValidPassword(confirmPassword), confirmPassword == password, !confirmPassword.isEmpty else {
            showValidationError(view, message: "비밀번호를 다시 한 번 확인해 주세요")
            return false
        }
        hideValidationError(view, message: "")
        return true
    }
    
    // MARK: - 정규식 함수
    func isValidUserName(_ username: String) -> Bool {
        let usernameRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let usernamePred = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return usernamePred.evaluate(with: username)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*()_+\\-=?.,<>]).{8,15}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
    
    // MARK: - UI 업데이트 메서드
    func showValidationError(_ view: CustomLabelTextFieldView, message: String) {
        view.updateValidationText(message, isHidden: false, color: AppColor.red)
        view.textField.layer.borderColor = AppColor.red?.cgColor
        view.textField.backgroundColor = AppColor.red?.withAlphaComponent(0.1)
        view.textField.textColor = AppColor.red
        view.iconImageView.tintColor = AppColor.red
    }
    
    func hideValidationError(_ view: CustomLabelTextFieldView, message: String) {
        view.updateValidationText(message, isHidden: false, color: AppColor.purple100)
        view.textField.layer.borderColor = AppColor.purple100?.cgColor
        view.textField.backgroundColor = AppColor.purple10
        view.textField.textColor = AppColor.purple100
        view.iconImageView.tintColor = AppColor.purple100
    }
}
