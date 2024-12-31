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
    
    // MARK: - 유저 이름 저장
    @MainActor public func saveUserName(_ name: String) async {
        let context = container.mainContext
        
        do {
            let fetchDescriptor = FetchDescriptor<UserData>()
            let users = try context.fetch(fetchDescriptor)
            
            // 기존 데이터 삭제
            for user in users {
                context.delete(user)
            }
            
            // 새로운 데이터 저장
            let user = UserData(userName: name)
            context.insert(user)
            
            // 한번에 저장
            try context.save()
            print("✅ 유저 이름 저장 성공: \(name)")
        } catch {
            print("❌ 유저 이름 저장 실패: \(error)")
        }
    }
    
    // MARK: - 유저 이름 불러오기
    @MainActor public func fetchUserName() async -> String? {
        let context = container.mainContext
        
        do {
            let fetchDescriptor = FetchDescriptor<UserData>()
            let users = try context.fetch(fetchDescriptor)
            return users.first?.userName // 첫 번째 유저 이름 반환
        } catch {
            print("❌ 유저 이름 불러오기 실패: \(error)")
            return nil
        }
    }
    
    // MARK: - 유저 데이터 삭제
    @MainActor public func deleteUserData() async throws {
        let context = container.mainContext
        let fetchDescriptor = FetchDescriptor<UserData>()
        let users = try context.fetch(fetchDescriptor)
        
        for user in users {
            context.delete(user)
        }
        try context.save()
        print("✅ 기존 유저 데이터 삭제 완료")
    }
}
