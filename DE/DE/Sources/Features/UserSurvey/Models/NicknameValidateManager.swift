// Copyright © 2024 DRINKIG. All rights reserved
import UIKit

import CoreModule
import Network

final class NicknameValidateManager {
    
    // MARK: - Properties
    private let networkService = MemberService()
    
    var isNicknameValid = false
    var isNicknameCanUse = false //false 이면 닉네임 중복 상태
    
    // MARK: - Validation Methods
    
    func validateNickname(_ view: CustomTextFieldView) -> Bool {
        // 닉네임이 비어있는지 확인
        guard let username = view.text, !username.isEmpty else {
            showValidationError(view, message: "닉네임을 입력해 주세요")
            return false
        }
        
        // 닉네임 길이 검증
           if username.count < 3 {
               showValidationError(view, message: "3자 이상의 닉네임을 입력해 주세요")
               return false
           } else if username.count > 15 {
               showValidationError(view, message: "15자 이하의 닉네임만 가능해요")
               return false
           }
        
        // 닉네임 중복 확인
        guard isNicknameCanUse else {
            showValidationError(view, message: "닉네임 중복 확인이 필요해요")
            return true
        }
        
        // 모든 검증 통과
        hideValidationError(view, message: "")
        return true
    }
    
    func checkNicknameDuplicate(nickname: String, view: CustomTextFieldView) {
        networkService.checkNickname(name: nickname) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                
                if response { // 닉네임 사용 가능 CanUse: true
                    self.hideValidationError(view, message: "사용 가능한 닉네임이에요")
                    self.isNicknameCanUse = false
                } else { // 닉네임 중복
                    self.showValidationError(view, message: "이미 사용 중인 닉네임이에요")
                    self.isNicknameCanUse = true
                }
                
            case .failure(let error):
                print("네트워크 요청 실패: \(error)")
                self.showValidationError(view, message: "네트워크 오류가 발생했습니다. 다시 시도해주세요.")
            }
        }
    }
    
    // MARK: - 정규식 함수
    func isValidUserName(_ username: String) -> Bool {
        let usernameRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let usernamePred = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return usernamePred.evaluate(with: username)
    }
    
    // MARK: - UI 업데이트 메서드
    private func showValidationError(_ view: CustomTextFieldView, message: String) {
        view.updateValidationText(message, isHidden: false, color: AppColor.red)
        view.textField.layer.borderColor = AppColor.red?.cgColor
        view.textField.backgroundColor = AppColor.red?.withAlphaComponent(0.1)
        view.textField.textColor = AppColor.red
    }
    
    private func hideValidationError(_ view: CustomTextFieldView, message: String) {
        view.updateValidationText(message, isHidden: false, color: AppColor.purple100)
        view.textField.layer.borderColor = AppColor.purple100?.cgColor
        view.textField.backgroundColor = AppColor.purple10
        view.textField.textColor = AppColor.purple100
    }
}
