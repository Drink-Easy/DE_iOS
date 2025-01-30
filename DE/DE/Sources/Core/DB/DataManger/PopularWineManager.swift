// Copyright © 2024 DRINKIG. All rights reserved

import SwiftData
import UIKit

/// 인기 와인 데이터를 관리하는 싱글톤 매니저
public final class PopularWineManager {
    
    /// 싱글톤 인스턴스
    public static let shared = PopularWineManager()
    
    /// SwiftData 컨테이너 초기화
    lazy var container: ModelContainer = {
        do {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
            let container = try ModelContainer(
                for: PopularWineList.self, WineData.self,
                configurations: configuration
            )
            print("✅ SwiftData 초기화 성공!")
            return container
        } catch {
            print("❌ SwiftData 초기화 실패: \(error.localizedDescription)")
            fatalError("SwiftData 초기화 실패: \(error.localizedDescription)")
        }
    }()
    
    private init() {} // 싱글톤이므로 외부에서 인스턴스 생성 방지
    
    // MARK: - Public Methods
    
    /// 와인 데이터를 저장하는 메서드 (없으면 생성, 있으면 업데이트)
    /// - Parameters:
    ///   - wineData: 저장할 와인 데이터 배열
    ///   - expirationInterval: 데이터 유효기간 (초 단위)
    /// - Throws: SwiftData 저장 오류 발생 시 예외 처리
    @MainActor
    public func saveWineData(wineData: [WineData], expirationInterval: TimeInterval) throws {
        let context = container.mainContext
        let expirationDate = Date().addingTimeInterval(expirationInterval)
        
        // ✅ 기존 데이터를 가져오거나 새로 생성
        let wineList = try fetchOrCreateWineList(in: context)
        wineList.wines = wineData
        wineList.timestamp = expirationDate
        
        try context.save()
        print("✅ 와인 데이터 저장 완료!")
    }
    
    /// 와인 데이터 불러오기 (만료된 데이터는 자동 삭제)
    /// - Returns: 저장된 와인 데이터 배열
    /// - Throws: SwiftData 불러오기 오류 발생 시 예외 처리
    @MainActor
    public func fetchWineDataList() throws -> [WineData] {
        let context = container.mainContext
        
        // ✅ 데이터가 만료되었는지 확인 후 삭제
        if try isWineDataExpired(in: context) {
            try deleteExpiredWineData()
            return []
        }
        
        return try fetchOrCreateWineList(in: context).wines
    }
    
    /// 만료된 와인 데이터 삭제
    /// - Throws: SwiftData 삭제 오류 발생 시 예외 처리
    @MainActor
    public func deleteExpiredWineData() throws {
        let context = container.mainContext
        
        let descriptor = FetchDescriptor<PopularWineList>()
        let wineLists = try context.fetch(descriptor)
        
        for wineList in wineLists {
            context.delete(wineList)
        }
        
        try context.save()
        print("✅ 만료된 와인 데이터 삭제 완료: \(wineLists.count)개")
    }
    
    // MARK: - Private Methods
    
    /// 와인 데이터가 만료되었는지 확인
    /// - Parameter context: SwiftData 컨텍스트
    /// - Returns: 데이터가 만료되었으면 `true`, 유효하면 `false`
    /// - Throws: SwiftData 불러오기 오류 발생 시 예외 처리
    private func isWineDataExpired(in context: ModelContext) throws -> Bool {
        let descriptor = FetchDescriptor<PopularWineList>()
        let wineLists = try context.fetch(descriptor)
        
        guard let wineList = wineLists.first else {
            return true // 데이터가 없으면 만료된 것으로 간주
        }
        
        return wineList.timestamp < Date()
    }
    
    /// 와인 데이터 목록을 가져오거나 새로 생성
    /// - Parameter context: SwiftData 컨텍스트
    /// - Returns: `PopularWineList` 객체
    /// - Throws: SwiftData 불러오기 오류 발생 시 예외 처리
    private func fetchOrCreateWineList(in context: ModelContext) throws -> PopularWineList {
        let descriptor = FetchDescriptor<PopularWineList>()
        let wineLists = try context.fetch(descriptor)
        
        if let existingList = wineLists.first {
            return existingList
        }
        
        let newWineList = PopularWineList(wines: [], timestamp: Date())
        context.insert(newWineList)
        return newWineList
    }
}

// MARK: - 에러 정의

/// PopularWineManager 관련 오류 정의
public enum PopularWineManagerError: Error {
    /// 저장된 와인 리스트를 찾을 수 없음
    case wineListNotFound
}
