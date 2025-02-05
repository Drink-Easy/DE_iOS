// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SwiftData

/// 🔥 PersonalData(개인 정보) 저장 및 관리하는 싱글톤 매니저
public final class PersonalDataManager {
    
    /// 싱글톤 인스턴스
    public static let shared = PersonalDataManager()
    
    private init() {} // 외부 인스턴스 생성 방지

    // MARK: - Public Methods
    
    /// 🔹 PersonalData 생성 (초기 생성)
    /// - Parameters:
    ///   - userId: 유저 ID
    ///   - userName: 유저 이름 (Optional)
    ///   - userImageURL: 유저 프로필 이미지 URL (Optional)
    ///   - userCity: 유저가 선택한 지역 (Optional)
    ///   - authType: 로그인 방식 (Optional)
    ///   - email: 이메일 (Optional)
    ///   - adult: 성인 여부 (Default: false)
    /// - Throws: `PersonalDataError.saveFailed`
    @MainActor
    public func createPersonalData(
        for userId: Int,
        userName: String? = nil,
        userImageURL: String? = nil,
        userCity: String? = nil,
        authType: String? = nil,
        email: String? = nil,
        adult: Bool? = false
    ) async throws {
        let context = UserDataManager.shared.container.mainContext
        
        let user = try UserDataManager.shared.fetchUser(userId: userId)

        if user.userInfo != nil {
            print("✅ PersonalData가 이미 존재합니다.")
            return
        }

        let newPersonalData = PersonalData(
            userName: userName,
            userImageURL: userImageURL,
            userCity: userCity,
            authType: authType,
            email: email,
            adult: adult,
            user: user
        )
        user.userInfo = newPersonalData

        do {
            try context.save()
            print("✅ 새로운 PersonalData 생성 완료!")
        } catch {
            throw PersonalDataError.saveFailed(reason: error.localizedDescription)
        }
    }
    
    /// 🔹 PersonalData 불러오기
    /// - Parameter userId: 유저 ID
    /// - Returns: 해당 유저의 `PersonalData` 객체
    /// - Throws: `PersonalDataError.personalDataNotFound`
    @MainActor
    public func fetchPersonalData(for userId: Int) async throws -> PersonalData {
        let user = try UserDataManager.shared.fetchUser(userId: userId)
        
        guard let personalData = user.userInfo else {
            throw PersonalDataError.personalDataNotFound
        }

        return personalData
    }
    
    /// 🔹 PersonalData 업데이트
    /// - Parameters:
    ///   - userId: 유저 ID
    ///   - userName: 유저 이름 (Optional)
    ///   - userImageURL: 프로필 이미지 URL (Optional)
    ///   - userCity: 선택한 지역 (Optional)
    ///   - authType: 로그인 방식 (Optional)
    ///   - email: 이메일 (Optional)
    ///   - adult: 성인 여부 (Optional)
    /// - Throws: `PersonalDataError.personalDataNotFound`, `PersonalDataError.saveFailed`
    @MainActor
    public func updatePersonalData(
        for userId: Int,
        userName: String? = nil,
        userImageURL: String? = nil,
        userCity: String? = nil,
        authType: String? = nil,
        email: String? = nil,
        adult: Bool? = nil
    ) async throws {
        let context = UserDataManager.shared.container.mainContext

        let user = try UserDataManager.shared.fetchUser(userId: userId)
        
        guard let personalData = user.userInfo else {
            try await createPersonalData(for: userId, userName: userName, userImageURL: userImageURL, userCity: userCity, authType: authType, email: email, adult: adult)
            return
        }

        if let userName = userName { personalData.userName = userName }
        if let userImageURL = userImageURL { personalData.userImageURL = userImageURL }
        if let userCity = userCity { personalData.userCity = userCity }
        if let authType = authType { personalData.authType = authType }
        if let email = email { personalData.email = email }
        if let adult = adult { personalData.adult = adult }

        do {
            try context.save()
            print("✅ PersonalData 업데이트 성공!")
        } catch {
            throw PersonalDataError.saveFailed(reason: error.localizedDescription)
        }
    }
    
    /// 🔹 PersonalData의 모든 값이 nil인지 확인
    /// - Parameter userId: 유저 ID
    /// - Returns: 모든 값이 nil이면 `true`, 그렇지 않으면 `false`
    /// - Throws: `PersonalDataError.personalDataNotFound`
    @MainActor
    public func checkPersonalDataHasNil(for userId: Int) async throws -> Bool {
        let user = try UserDataManager.shared.fetchUser(userId: userId)
        guard let personalData = user.userInfo else {
            throw PersonalDataError.personalDataNotFound
        }

        return personalData.hasNilProperty()
    }

    /// 🔹 특정 두 개의 필드(`userName`, `userImageURL`)만 nil인지 확인
    /// - Parameter userId: 유저 ID
    /// - Returns: 두 개의 필드가 nil이면 `true`, 그렇지 않으면 `false`
    /// - Throws: `PersonalDataError.personalDataNotFound`
    @MainActor
    public func checkPersonalDataTwoPropertyHasNil(for userId: Int) async throws -> Bool {
        let user = try UserDataManager.shared.fetchUser(userId: userId)
        guard let personalData = user.userInfo else {
            throw PersonalDataError.personalDataNotFound
        }

        return personalData.checkTwoProperty()
    }
    
    /// 🔹 PersonalData 삭제
    /// - Parameter userId: 유저 ID
    /// - Throws: `PersonalDataError.personalDataNotFound`, `PersonalDataError.saveFailed`
    @MainActor
    public func deletePersonalData(for userId: Int) async throws {
        let context = UserDataManager.shared.container.mainContext

        let user = try UserDataManager.shared.fetchUser(userId: userId)
        guard let personalData = user.userInfo else {
            throw PersonalDataError.personalDataNotFound
        }

        context.delete(personalData)
        user.userInfo = nil

        do {
            try context.save()
            print("✅ PersonalData 삭제 완료!")
        } catch {
            throw PersonalDataError.saveFailed(reason: error.localizedDescription)
        }
    }
    
    /// 🔹 유저 닉네임 가져오기
    /// - Parameter userId: 유저 ID
    /// - Returns: 유저 닉네임
    /// - Throws: `PersonalDataError.personalDataNotFound`
    @MainActor
    public func fetchUserName(for userId: Int) async throws -> String {
        let user = try UserDataManager.shared.fetchUser(userId: userId)

        guard let userName = user.userInfo?.userName, !userName.isEmpty else {
            throw PersonalDataError.cannotFetchName
        }

        return userName
    }
}

// MARK: - 에러 정의
public enum PersonalDataError: Error {
    /// PersonalData가 존재하지 않음
    case personalDataNotFound
    case cannotFetchName
    /// 데이터 저장 실패
    case saveFailed(reason: String)
}

extension PersonalDataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .personalDataNotFound:
            return "🚨 [오류] PersonalData를 찾을 수 없습니다."
        case .cannotFetchName:
            return "설정된 유저 이름이 없습니다."
        case .saveFailed(let reason):
            return "🚨 [오류] PersonalData 저장 실패. 원인: \(reason)"
        }
    }
}
