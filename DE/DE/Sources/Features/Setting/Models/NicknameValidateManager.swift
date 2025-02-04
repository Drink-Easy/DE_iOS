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
        
        let koreanJamoRegex = "[ㄱ-ㅎㅏ-ㅣ]" // ✅ 한글 자모 포함 여부 검사
        let koreanCompleteRegex = "[가-힣]" // ✅ 한글 완성형 포함 여부 검사
        let englishRegex = "[A-Za-z]" // ✅ 영어 포함 여부 검사
        let numberRegex = "[0-9]" // ✅ 숫자 포함 여부 검사
        let specialCharRegex = "[^가-힣ㄱ-ㅎㅏ-ㅣA-Za-z0-9]" // ✅ 특수문자 포함 여부 검사
        
        // 한글 자모 포함 여부
        let containsKoreanJamo = username.range(of: koreanJamoRegex, options: .regularExpression) != nil
        // 한글 완성형 포함 여부
        let containsKoreanComplete = username.range(of: koreanCompleteRegex, options: .regularExpression) != nil
        // 영어 포함 여부
        let containsEnglish = username.range(of: englishRegex, options: .regularExpression) != nil
        // 숫자 포함 여부
        let containsNumber = username.range(of: numberRegex, options: .regularExpression) != nil
        // 특수문자 포함 여부
        let containsSpecialChar = username.range(of: specialCharRegex, options: .regularExpression) != nil
        
        let length = username.count
        
        // **한글 자모만 포함 → 최대 6자**
        if containsKoreanJamo && !containsKoreanComplete && !containsEnglish && !containsNumber && !containsSpecialChar {
            if length > 6 {
                showValidationError(view, message: "한글 자모만 포함된 닉네임은 6자 이하만 가능해요")
                return false
            }
        }
        // **한글 완성형만 포함 → 최대 6자**
        else if containsKoreanComplete && !containsKoreanJamo && !containsEnglish && !containsNumber && !containsSpecialChar {
            if length > 6 {
                showValidationError(view, message: "한글 닉네임은 6자 이하만 가능해요")
                return false
            }
        }
        // **영어만 포함 → 최대 10자**
        else if containsEnglish && !containsKoreanJamo && !containsKoreanComplete && !containsNumber && !containsSpecialChar {
            if length > 10 {
                showValidationError(view, message: "영어 닉네임은 10자 이하만 가능해요")
                return false
            }
        }
        // **숫자만 포함 → 최대 10자**
        else if containsNumber && !containsKoreanJamo && !containsKoreanComplete && !containsEnglish && !containsSpecialChar {
            if length > 10 {
                showValidationError(view, message: "숫자만 포함된 닉네임은 10자 이하만 가능해요")
                return false
            }
        }
        // **한글(자모 또는 완성형) + 영어 + 숫자 + 특수문자 포함 → 최대 6자**
        else {
            if length > 6 {
                showValidationError(view, message: "한글, 영어, 숫자, 특수문자가 포함된 닉네임은 6자 이하만 가능해요")
                return false
            }
        }
        
        isLengthValid = true
        
        // 닉네임 중복 확인
        guard isNicknameCanUse else {
            showValidationError(view, message: "닉네임 중복 확인이 필요해요")
            return true
        }
        
        // 모든 검증 통과
        hideValidationError(view, message: "")
        return true
    }
    
    public func checkNicknameDuplicate(nickname: String, view: CustomTextFieldView) async {
        do {
            let data = try await networkService.checkNickname(name: nickname)
            if data {
                self.hideValidationError(view, message: "사용 가능한 닉네임이에요")
                self.isNicknameCanUse = true
            } else {
                self.showValidationError(view, message: "이미 사용 중인 닉네임이에요")
                self.isNicknameCanUse = false
            }
        } catch {
            self.showValidationError(view, message: "네트워크 오류가 발생했습니다. 다시 시도해주세요.")
            self.isNicknameCanUse = false
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
