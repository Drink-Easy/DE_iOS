// Copyright © 2024 DRINKIG. All rights reserved

import SwiftData
import UIKit

public final class WineDataManager {
    public static let shared = WineDataManager()
    
    lazy var container: ModelContainer = {
        do {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
            let container = try ModelContainer(
                for: WineList.self, WineData.self,
                configurations: configuration
            )
            print("✅ SwiftData 초기화 성공!")
            return container
        } catch {
            print("❌ SwiftData 초기화 실패: \(error.localizedDescription)")
            fatalError("SwiftData 초기화 실패: \(error.localizedDescription)")
        }
    }()
    
    private init() {}
    
    /// 와인 데이터를 저장하는 메서드
    @MainActor
    public func saveWineData(userId: Int, wineListType: WineListType, wineData: [WineData], expirationInterval: TimeInterval) throws {
        let context = container.mainContext
        
        // 1. userId 검사
        let user = try fetchUser(by: userId, in: context)
        
        do {
            let wineList = try fetchWineList(for: userId, type: wineListType, in: context)
            wineList.wines.removeAll()
            wineList.wines.append(contentsOf: wineData)
            wineList.timestamp = Date().addingTimeInterval(expirationInterval)
        } catch WineDataManagerError.wineListNotFound {
            let newWineList = WineList(type: wineListType, wines: wineData, timestamp: Date().addingTimeInterval(expirationInterval), user: user)
            context.insert(newWineList)
        }
        
        try context.save()
        print("✅ 와인 데이터 저장 완료!")
    }
    
    /// 와인 데이터 불러오기
    @MainActor
    public func fetchWineDataList(userId: Int, wineListType: WineListType) throws -> [WineData] {
        let context = container.mainContext
        
        // 1. 유효 기간이 지난 데이터 삭제
        try deleteExpiredWineData()
        
        // 2. 해당 userId와 wineListType에 맞는 WineList 검색
        let wineList = try fetchWineList(for: userId, type: wineListType, in: context)
        
        // 3. 와인 데이터를 반환
        return wineList.wines
    }
    
    /// 만료된 와인 데이터 삭제하기
    @MainActor
    public func deleteExpiredWineData() throws {
        let context = container.mainContext
        let currentDate = Date()
        
        let descriptor = FetchDescriptor<WineList>(predicate: #Predicate { wineList in
            wineList.timestamp < currentDate
        })
        
        let expiredWineLists = try context.fetch(descriptor)
        
        for wineList in expiredWineLists {
            context.delete(wineList)
        }
        
        try context.save()
        print("✅ 만료된 와인 데이터가 삭제되었습니다: \(expiredWineLists.count)개")
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
    private func fetchWineList(for userId: Int, type: WineListType, in context: ModelContext) throws -> WineList {
        let descriptor = FetchDescriptor<WineList>(predicate: #Predicate { $0.user?.userId == userId && $0.type == type.rawValue })
        let wineLists = try context.fetch(descriptor)
        
        guard let wineList = wineLists.first else {
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
