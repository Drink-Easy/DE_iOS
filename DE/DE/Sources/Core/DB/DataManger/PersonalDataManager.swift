// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SwiftData

public final class PersonalDataManager {
    public static let shared = PersonalDataManager()
    
    lazy var container: ModelContainer = {
        do {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
            let container = try ModelContainer(
                for: UserData.self, PersonalData.self,
                configurations: configuration
            )
            print("✅ SwiftData 초기화 성공!")
            return container
        } catch {
            print("❌ SwiftData 초기화 실패: \(error.localizedDescription)")
            fatalError("SwiftData 초기화 실패: \(error.localizedDescription)")
        }
    }()
    
    //MARK: - Methods
    
    /// personal data 생성
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
        let context = container.mainContext

        // 1. 사용자 확인
        let user = try fetchUser(by: userId, in: context)

        // 2. 기존 PersonalData 존재 여부 확인
        if user.userInfo != nil {
            print("✅ PersonalData가 이미 존재합니다.")
            return
        }

        // 3. PersonalData 생성
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

        // 4. 저장
        do {
            try context.save()
            print("✅ 새로운 PersonalData가 생성되었습니다.")
        } catch {
            throw PersonalDataError.saveFailed(reason: error.localizedDescription)
        }
    }
    
    /// personal data 불러오기
    @MainActor
    public func fetchPersonalData(for userId: Int) async throws -> PersonalData {
        let context = container.mainContext

        // 1. 사용자 확인
        let user = try fetchUser(by: userId, in: context)

        // 2. PersonalData 확인 및 반환
        guard let personalData = user.userInfo else {
            throw PersonalDataError.userNotFound
        }

        return personalData
    }
    
    /// personal data 업데이트
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
        let context = container.mainContext

        // 1. 사용자 확인
        let user = try fetchUser(by: userId, in: context)

        // 2. PersonalData 확인
        guard let personalData = user.userInfo else {
            throw PersonalDataError.userNotFound
        }

        // 3. 필드별 업데이트
        if let userName = userName {
            personalData.userName = userName
        }
        if let userImageURL = userImageURL {
            personalData.userImageURL = userImageURL
        }
        if let userCity = userCity {
            personalData.userCity = userCity
        }
        if let authType = authType {
            personalData.authType = authType
        }
        if let email = email {
            personalData.email = email
        }
        if let adult = adult {
            personalData.adult = adult
        }

        // 4. 저장
        do {
            try context.save()
            print("✅ PersonalData 업데이트 성공!")
        } catch {
            throw PersonalDataError.saveFailed(reason: error.localizedDescription)
        }
    }
    
    @MainActor
    public func checkPersonalDataHasNil(for userId: Int) async throws -> Bool {
        let context = container.mainContext

        // 1. 사용자 확인
        let user = try fetchUser(by: userId, in: context)

        // 2. PersonalData 확인
        guard let personalData = user.userInfo else {
            throw PersonalDataError.userNotFound
        }

        // 3. nil 값 검증
        return personalData.hasNilProperty()
    }

    // TODO : 프로퍼티 2개만 nil 검사 - name, image
    
    @MainActor
    public func checkPersonalDataTwoPropertyHasNil(for userId: Int) async throws -> Bool {
        let context = container.mainContext

        // 1. 사용자 확인
        let user = try fetchUser(by: userId, in: context)

        // 2. PersonalData 확인
        guard let personalData = user.userInfo else {
            throw PersonalDataError.userNotFound
        }

        // 3. nil 값 검증
        return personalData.checkTwoProperty()
    }
    
    
    
    /// personal data  삭제
    @MainActor
    public func deletePersonalData(for userId: Int) async throws {
        let context = container.mainContext

        // 1. 사용자 확인
        let user = try fetchUser(by: userId, in: context)

        // 2. PersonalData 확인
        guard let personalData = user.userInfo else {
            throw PersonalDataError.userNotFound
        }

        // 3. PersonalData 삭제
        context.delete(personalData)
        user.userInfo = nil // 관계 해제

        // 4. 저장
        do {
            try context.save()
            print("✅ PersonalData가 삭제되었습니다.")
        } catch {
            throw PersonalDataError.saveFailed(reason: error.localizedDescription)
        }
    }
    
    //MARK: - user nickname 관련 함수
    @MainActor
    public func fetchUserName(for userId: Int) async throws -> String {
        let context = container.mainContext

        // 1. 사용자 확인
        let user = try fetchUser(by: userId, in: context)

        // 2. 유저 이름 반환
        guard let userName = user.userInfo?.userName, !userName.isEmpty else {
            throw PersonalDataError.saveFailed(reason: "유저 이름이 설정되지 않았습니다.")
        }

        return userName
    }
    
    // MARK: - 내부 함수
    
    /// 유저 검증
    @MainActor
    private func fetchUser(by userId: Int, in context: ModelContext) throws -> UserData {
        let descriptor = FetchDescriptor<UserData>(predicate: #Predicate { $0.userId == userId })
        let users = try context.fetch(descriptor)
        
        guard let user = users.first else {
            throw WishlistError.userNotFound
        }
        
        return user
    }
}

public enum PersonalDataError: Error {
    case userNotFound
    case saveFailed(reason: String)
    case unknown
}

extension PersonalDataError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "사용자를 찾을 수 없습니다."
        case .saveFailed(let reason):
            return "데이터를 저장하는데 실패하였습니다. 원인: \(reason)"
        case .unknown:
            return "알 수 없는 에러가 발생했습니다."
        }
    }
}
