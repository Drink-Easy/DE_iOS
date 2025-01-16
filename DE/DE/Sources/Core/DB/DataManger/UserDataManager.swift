// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import SwiftData

public final class UserDataManager {
    public static let shared = UserDataManager() // 싱글톤
    
    let container: ModelContainer
    
    private init() {
        do {
            container = try ModelContainer(for: UserData.self)
        } catch {
            fatalError("SwiftData 초기화 실패: \(error.localizedDescription)")
        }
    }
    
    /// 유저 ID 생성  -> 로그인
    @MainActor public func createUser(userId: Int) async {
        let context = container.mainContext
        
        do {
            // 1. 이미 존재하는지 확인
            let descriptor = FetchDescriptor<UserData>(predicate: #Predicate { $0.userId == userId })
            let existingUsers = try context.fetch(descriptor)
            
            if existingUsers.isEmpty {
                let newUser = UserData(userId: userId)
                context.insert(newUser)
                try context.save()
                print("✅ 유저 ID 생성 완료: \(userId)")
            } else {
                print("⚠️ 유저 ID가 이미 존재합니다: \(userId)")
            }
        } catch {
            print("❌ 유저 ID 생성 실패: \(error)")
        }
    }
    
    /// 유저 데이터 삭제 -> 탈퇴에서 사용
    @MainActor
    func deleteUser(userId: Int) {
        let context = container.mainContext
        
        do {
            // 1. 특정 userId로 유저 검색
            let descriptor = FetchDescriptor<UserData>(predicate: #Predicate { $0.userId == userId })
            let users = try context.fetch(descriptor)
            
            // 2. 검색된 유저 삭제
            for user in users {
                context.delete(user)
            }
            
            // 3. 변경 사항 저장
            try context.save()
            print("✅ 유저 정보 삭제 완료: \(userId)")
        } catch {
            print("❌ 유저 정보 삭제 실패: \(error)")
        }
    }
}
