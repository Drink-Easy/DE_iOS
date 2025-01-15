// Copyright © 2024 DRINKIG. All rights reserved

import SwiftData
import UIKit

public final class CommonDataManager {
    public static let shared = CommonDataManager()
    
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
    public func saveWineData(wineListType: WineListType, wineData: [WineData], expirationInterval: TimeInterval) throws {
        let context = container.mainContext
        
        // 1. 인기 와인 리스트 있는지 보고
        
        try context.save()
        print("✅ 인기 와인 데이터 저장 완료!")
    }
    
    /// 인기 와인 데이터 불러오기
    @MainActor
    public func fetchPopularWineDataList() throws -> [WineData] {
        let context = container.mainContext
        
        try deleteExpiredWineData()

        do {
            let wineList = try fetchWineList(type: .popular, in: context)
            return wineList.wines
        } catch {
            throw CommonDataManagerError.wineListNotFound
        }
    }
    
    /// 만료된 와인 데이터 삭제하기
    @MainActor
    public func deleteExpiredWineData(for type: WineListType = .popular) throws {
        let context = container.mainContext
        let currentDate = Date()

        let descriptor = FetchDescriptor<WineList>(predicate: #Predicate { wineList in
            wineList.timestamp < currentDate && wineList.type == type.rawValue
        })

        let expiredWineLists = try context.fetch(descriptor)
        expiredWineLists.forEach { context.delete($0) }

        try context.save()
        print("✅ 만료된 \(type.rawValue) 와인 데이터가 삭제되었습니다: \(expiredWineLists.count)개")
    }
    
    // MARK: - 내부 함수
    
    /// WineList의 와인 목록 가져오기
    private func fetchWineList(type: WineListType = .popular, in context: ModelContext) throws -> WineList {
        let descriptor = FetchDescriptor<WineList>(predicate: #Predicate { $0.type == type.rawValue })
        let wineLists = try context.fetch(descriptor)
        
        // 저장된 인기 와인 가져오기
        guard let wineList = wineLists.first else {
            throw WineDataManagerError.wineListNotFound
        }
        
        return wineList
    }
    
}

// MARK: - 에러 정의
public enum CommonDataManagerError: Error {
    case wineListNotFound
    case saveFailed(reason: String)
}

extension CommonDataManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .wineListNotFound:
            return "와인 리스트를 찾을 수 없습니다."
        case .saveFailed(let reason):
            return "와인 데이터를 저장하는 데 실패했습니다. 이유: \(reason)"
        }
    }
}
