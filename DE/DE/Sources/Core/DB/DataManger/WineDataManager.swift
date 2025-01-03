// Copyright © 2024 DRINKIG. All rights reserved

import SwiftData
import Foundation

public final class WineDataManager {
    public static let shared = WineDataManager()
    let container: ModelContainer
    
    private init() {
        do {
            container = try ModelContainer(for: WineData.self, WineList.self)
        } catch {
            fatalError("SwiftData 초기화 실패: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 와인 저장
    
    @MainActor
    public func saveWines(_ wines: [WineData], type: WineListType) {
        let context = container.mainContext
        
        do {
            // 1. 기존 리스트 삭제
            try deleteWineList(type: type)
            
            // 2. 새로운 WineList 생성
            let newList = WineList(type: type.rawValue)
            newList.wines.append(contentsOf: wines) // 관계 추가
            
            context.insert(newList) // 저장
            try context.save()
            print("\(type.rawValue) 와인 저장 성공!")
        } catch {
            print("\(type.rawValue) 와인 저장 실패: \(error)")
        }
    }
    
    // MARK: - 와인 조회

    @MainActor
    public func fetchWines(type: WineListType) -> [WineData] {
        let context = container.mainContext
        let descriptor = FetchDescriptor<WineList>(
            predicate: #Predicate { $0.type == type.rawValue } // ✅ String으로 비교
        )
        
        do {
            if let wineList = try context.fetch(descriptor).first {
                return wineList.wines // ✅ 저장된 와인 리스트 반환
            } else {
                return []
            }
        } catch {
            print("❌ \(type.rawValue) 조회 실패: \(error)")
            return []
        }
    }
    
    // MARK: - 와인 삭제
    
    @MainActor
    public func deleteWineList(type: WineListType) throws {
        let context = container.mainContext
        let descriptor = FetchDescriptor<WineList>(
            predicate: #Predicate { $0.type == type.rawValue } // ✅ String으로 비교
        )
        let wineLists = try context.fetch(descriptor)
        
        for list in wineLists {
            context.delete(list)
        }
        try context.save()
        print("✅ \(type.rawValue) 삭제 완료!")
    }
    
    // MARK: - 전체 데이터 초기화
    
    /// 전체 와인 데이터 초기화
    @MainActor
    public func deleteAllWines() {
        let context = container.mainContext
        do {
            let allWines = try context.fetch(FetchDescriptor<WineList>())
            for wineList in allWines {
                context.delete(wineList)
            }
            try context.save()
            print("모든 와인 데이터 삭제 완료!")
        } catch {
            print("데이터 삭제 실패: \(error)")
        }
    }
}
