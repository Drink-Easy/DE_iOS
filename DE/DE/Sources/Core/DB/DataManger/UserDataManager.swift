// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import SwiftData

public final class UserDataManager {
    public static let shared = UserDataManager() // 싱글톤
    
    let container: ModelContainer
    
    private init() {
        do {
            _ = ModelConfiguration(isStoredInMemoryOnly: false)
            container = try ModelContainer(
                for: UserData.self, PersonalData.self, Wishlist.self,
                TastingNoteList.self, TastingNote.self, MyWineList.self,
                SavedWineDataModel.self, APIControllerCounter.self, APICounter.self, RecommendWineList.self, WineData.self
            )
            print("✅ UserData SwiftData 초기화 성공!")
        } catch {
            fatalError("❌ SwiftData 초기화 실패: \(error.localizedDescription)")
        }
    }
    
    /// 유저 ID 생성  -> 로그인
    @MainActor
    public func createUser(userId: Int) async {
        let context = container.mainContext
        
        do {
            let descriptor = FetchDescriptor<UserData>(predicate: #Predicate { $0.userId == userId })
            let existingUsers = try context.fetch(descriptor)
            
            // ✅ 유저가 이미 존재하면 생성하지 않음
            guard existingUsers.isEmpty else {
                print("⚠️ 유저 ID(\(userId))가 이미 존재합니다.")
                return
            }
            
            let newUser = UserData(userId: userId)
            context.insert(newUser)
            try context.save()
            
            // ✅ 저장 후 다시 확인 (추가적인 안전장치)
            let checkUsers = try context.fetch(descriptor)
            if !checkUsers.isEmpty {
                print("✅ 유저 ID 생성 완료: \(userId)")
            } else {
                print("❌ 유저 ID 생성 실패(비정상 저장 오류 발생)")
            }
            
        } catch {
            print("❌ 유저 ID 생성 중 오류 발생: \(error.localizedDescription)")
        }
    }
    
    /// 유저 데이터 삭제 -> 탈퇴에서 사용
    @MainActor
    public func deleteUser(userId: Int) async {
        let context = container.mainContext
        
        do {
            let descriptor = FetchDescriptor<UserData>(predicate: #Predicate { $0.userId == userId })
            let users = try context.fetch(descriptor)
            
            // ✅ 삭제할 유저가 없는 경우 처리
            guard !users.isEmpty else {
                print("⚠️ 삭제할 유저(\(userId))가 존재하지 않습니다.")
                return
            }
            
            // ✅ 유저 삭제
            for user in users {
                context.delete(user)
            }
            
            try context.save()
            
            // ✅ 삭제 후 다시 확인 (추가적인 안전장치)
            let checkUsers = try context.fetch(descriptor)
            if checkUsers.isEmpty {
                print("✅ 유저 정보 삭제 완료: \(userId)")
            } else {
                print("❌ 유저 정보 삭제 실패(비정상 삭제 오류 발생)")
            }
            
        } catch {
            print("❌ 유저 정보 삭제 중 오류 발생: \(error.localizedDescription)")
        }
    }
    
    /// ✅ 특정 유저 데이터를 가져오는 함수
    /// - Parameter userId: 찾고자 하는 유저의 ID
    /// - Returns: `UserData` 객체 반환
    /// - Throws: `UserDataManagerError.userNotFound` 예외 발생 가능
    @MainActor
    public func fetchUser(userId: Int) throws -> UserData {
        let context = container.mainContext
        
        let descriptor = FetchDescriptor<UserData>(predicate: #Predicate { $0.userId == userId })
        let users = try context.fetch(descriptor)
        
        guard let user = users.first else {
            throw UserDataManagerError.userNotFound
        }
        
        return user
    }
}

// MARK: - 에러 정의
public enum UserDataManagerError: Error {
    /// 사용자를 찾을 수 없음
    case userNotFound
}

extension UserDataManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "해당 유저 데이터를 찾을 수 없습니다."
        }
    }
}
