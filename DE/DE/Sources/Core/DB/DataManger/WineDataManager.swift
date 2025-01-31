// Copyright © 2024 DRINKIG. All rights reserved

import SwiftData
import UIKit

public final class WineDataManager {
    public static let shared = WineDataManager()
    
    private init() {} // 싱글톤
    
    /// 와인 데이터를 저장하는 메서드
    @MainActor
    public func saveWineData(userId: Int, wineListType: WineListType, wineData: [WineData], expirationInterval: TimeInterval) throws {
        let context = UserDataManager.shared.container.mainContext

        // ✅ 1. 사용자 확인
        let user = try UserDataManager.shared.fetchUser(userId: userId)
        print("🛠 유저 확인 완료: \(userId), 현재 저장된 WineList 개수: \(user.wines.count)")

        do {
            let wineList = try fetchWineList(for: userId, type: wineListType, in: context)
            print("🛠 기존 WineList 찾음, 데이터 업데이트 진행")
            wineList.wines.removeAll()
            wineList.wines.append(contentsOf: wineData)
            wineList.timestamp = Date().addingTimeInterval(expirationInterval)
        } catch WineDataManagerError.wineListNotFound {
            print("🛠 기존 WineList 없음, 새로 생성")
            let newWineList = WineList(
                type: wineListType,
                wines: wineData,
                timestamp: Date().addingTimeInterval(expirationInterval),
                user: user
            )
            context.insert(newWineList)
        }
        
        try context.save()
        print("✅ 와인 데이터 저장 완료! 현재 유저(\(userId))의 WineList 개수: \(user.wines.count)")
    }
    
    /// 와인 데이터 불러오기
    @MainActor
    public func fetchWineDataList(userId: Int, wineListType: WineListType) throws -> [WineData] {
        let context = UserDataManager.shared.container.mainContext
        
        // ✅ 1. 유효 기간이 지난 데이터 삭제
        deleteExpiredWineData(userId: userId)

        // ✅ 2. user 확인
        let user = try UserDataManager.shared.fetchUser(userId: userId)
        
        // ✅ 3. 특정 WineList 검색
        do {
            let wineList = try fetchWineList(for: userId, type: wineListType, in: context)
            print("🔍 WineList 검색 성공: \(wineList.wines.count)개 로드됨")
            return wineList.wines
        } catch {
            print("🚨 WineList 검색 실패: \(error.localizedDescription)")
            throw error
        }
    }
    
    /// 만료된 와인 데이터 삭제하기
    @MainActor
    public func deleteExpiredWineData(userId: Int) {
        let context = UserDataManager.shared.container.mainContext
        let currentDate = Date()

        do {
            let user = try UserDataManager.shared.fetchUser(userId: userId)

            // ✅ 해당 user의 만료된 WineList 필터링
            let expiredWineLists = user.wines.filter { $0.timestamp < currentDate }

            // ✅ 만료된 WineList 삭제
            for wineList in expiredWineLists {
                context.delete(wineList)
            }

            // ✅ 변경사항 저장
            if !expiredWineLists.isEmpty {
                try context.save()
                print("✅ 만료된 와인 데이터가 삭제되었습니다: \(expiredWineLists.count)개")
            } else {
                print("⚠️ 삭제할 만료된 와인 데이터가 없습니다.")
            }
        } catch let error as UserDataManagerError {
            print("❌ 유저 데이터 로드 실패: \(error.localizedDescription)")
        } catch {
            print("❌ 알 수 없는 오류 발생: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 내부 함수
    
    /// 사용자 검색
    private func fetchUser(by userId: Int, in context: ModelContext) throws -> UserData {
        let descriptor = FetchDescriptor<UserData>(predicate: #Predicate { $0.userId == userId })
        let users = try context.fetch(descriptor)
        
        guard let user = users.first else {
            throw WineDataManagerError.userNotFound
        }
        
        return user
    }
    
    /// WineList의 와인 목록 가져오기
    @MainActor
    private func fetchWineList(for userId: Int, type: WineListType, in context: ModelContext) throws -> WineList {
        // ✅ 1. user 가져오기
        let user = try UserDataManager.shared.fetchUser(userId: userId)

        // ✅ 2. 현재 유저의 `wines` 리스트 출력 (디버깅용)
        print("🔍 현재 유저(\(userId))의 저장된 와인 리스트 개수: \(user.wines.count)")
        for wine in user.wines {
            print("🔍 WineList 저장된 type: \(wine.type), timestamp: \(wine.timestamp)")
        }

        // ✅ 3. user.wines에서 type이 일치하는 WineList 찾기
        guard let wineList = user.wines.first(where: { $0.type == type.rawValue }) else {
            print("🚨 WineList 검색 실패: \(type.rawValue) 타입을 가진 WineList가 없음")
            throw WineDataManagerError.wineListNotFound
        }

        return wineList
    }
    
}

// MARK: - 에러 정의
public enum WineDataManagerError: Error {
    case userNotFound
    case wineListNotFound
}
