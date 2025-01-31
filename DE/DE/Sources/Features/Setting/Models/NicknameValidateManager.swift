// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import CoreModule
import Network

public class NicknameValidateManager {
    
    // MARK: - Properties
    public let networkService = MemberService()
    
    public var isNicknameValid = false
    public var isLengthValid = false
    public var isNicknameCanUse = false //false 이면 닉네임 중복 상태
    
    // MARK: - Validation Methods
    
    public func noNeedToCheck(_ view: CustomTextFieldView) -> Bool {
        hideValidationError(view, message: "")
        return true
    }
    
    public func validateNickname(_ view: CustomTextFieldView) -> Bool {
        // 닉네임이 비어있는지 확인
        guard let username = view.text, !username.isEmpty else {
            showValidationError(view, message: "닉네임을 입력해 주세요")
            return false
        }
        
        let koreanRegex = "^[가-힣]+$"  // 한글만 포함
        let englishRegex = "^[A-Za-z]+$" // 영어만 포함
        
        let isKoreanOnly = username.range(of: koreanRegex, options: .regularExpression) != nil
        let isEnglishOnly = username.range(of: englishRegex, options: .regularExpression) != nil
        
        // 닉네임 길이 검증
        if isKoreanOnly {
            if username.count < 2 {
                showValidationError(view, message: "2자 이상의 닉네임을 입력해 주세요")
                self.isLengthValid = true
                return false
            } else if username.count > 6 {
                showValidationError(view, message: "한글 닉네임은 6자 이하만 가능해요")
                self.isLengthValid = false
                return false
            }
        } else if isEnglishOnly {
            if username.count < 2 {
                showValidationError(view, message: "2자 이상의 닉네임을 입력해 주세요")
                self.isLengthValid = true
                return false
            } else if username.count > 10 {
                showValidationError(view, message: "영어 닉네임은 10자 이하만 가능해요")
                self.isLengthValid = false
                return false
            }
        } else { // 한글 + 영어 포함된 경우
            if username.count > 6 {
                showValidationError(view, message: "한글+영문 닉네임은 6자 이하만 가능해요")
                self.isLengthValid = false
                return false
            }
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
    
    public func checkNicknameDuplicate(nickname: String, view: CustomTextFieldView, completion: (() -> Void)? = nil) {
        networkService.checkNickname(name: nickname) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                if response {
                    self.hideValidationError(view, message: "사용 가능한 닉네임이에요")
                    self.isNicknameCanUse = true
                } else {
                    self.showValidationError(view, message: "이미 사용 중인 닉네임이에요")
                    self.isNicknameCanUse = false
                }
                
            case .failure(let error):
                print("네트워크 요청 실패: \(error)")
                self.showValidationError(view, message: "네트워크 오류가 발생했습니다. 다시 시도해주세요.")
                self.isNicknameCanUse = false
            }
            
            // 응답 완료 후 completion 호출
            completion?()
        }
    }
    
    // MARK: - 정규식 함수
    public func isValidUserName(_ username: String) -> Bool {
        let usernameRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let usernamePred = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return usernamePred.evaluate(with: username)
    }
    
    // MARK: - UI 업데이트 메서드
    public func showValidationError(_ view: CustomTextFieldView, message: String) {
        view.updateValidationText(message, isHidden: false, color: AppColor.red)
        view.textField.layer.borderColor = AppColor.red?.cgColor
        view.textField.backgroundColor = AppColor.red?.withAlphaComponent(0.1)
        view.textField.textColor = AppColor.red
    }
    
    public func hideValidationError(_ view: CustomTextFieldView, message: String) {
        view.updateValidationText(message, isHidden: false, color: AppColor.purple100)
        view.textField.layer.borderColor = AppColor.purple100?.cgColor
        view.textField.backgroundColor = AppColor.purple10
        view.textField.textColor = AppColor.purple100
    }
}
