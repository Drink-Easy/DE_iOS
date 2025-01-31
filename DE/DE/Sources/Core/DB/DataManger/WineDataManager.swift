// Copyright © 2024 DRINKIG. All rights reserved

import SwiftData
import UIKit

public final class WineDataManager {
    public static let shared = WineDataManager()
    
    private init() {} // 싱글톤
    
    // MARK: - Public Methods
    
    /// ✅ 추천 와인 데이터를 저장하는 메서드 (없으면 생성, 있으면 업데이트)
    /// - Parameters:
    ///   - userId: 와인을 저장할 사용자 ID
    ///   - wineData: 저장할 와인 데이터 리스트
    ///   - expirationInterval: 데이터 유효 기간 (초 단위)
    /// - Throws: 데이터 저장 실패 시 예외 발생
    @MainActor
    public func saveWineData(userId: Int, wineData: [WineData], expirationInterval: TimeInterval) throws {
        let context = UserDataManager.shared.container.mainContext
        
        // ✅ 1. 사용자 확인
        let user = try UserDataManager.shared.fetchUser(userId: userId)
        
        // ✅ 2. 추천 와인 리스트 가져오거나 새로 생성
        let wineList = try fetchOrCreateWineList(for: userId, in: context)
        
        // ✅ 3. 데이터 업데이트
        wineList.wines = wineData
        wineList.timestamp = Date().addingTimeInterval(expirationInterval)
        
        // ✅ 4. 저장
        do {
            try context.save()
            print("✅ 추천 와인 데이터 저장 완료! (유저: \(userId), 와인 개수: \(wineData.count))")
        } catch {
            throw WineDataManagerError.saveFailed(reason: error.localizedDescription)
        }
    }

    /// ✅ 추천 와인 데이터를 가져오는 메서드 (만료된 데이터는 자동 삭제)
    /// - Parameter userId: 데이터를 가져올 사용자 ID
    /// - Returns: 저장된 와인 데이터 리스트
    /// - Throws: 데이터 불러오기 실패 시 예외 발생
    @MainActor
    public func fetchWineDataList(userId: Int) throws -> [WineData] {
        let context = UserDataManager.shared.container.mainContext
        
        // ✅ 1. 데이터가 만료되었는지 확인 후 삭제
        let user = try UserDataManager.shared.fetchUser(userId: userId)
        if try isWineDataExpired(by: user, in: context) {
            try deleteExpiredWineData(userId: userId)
            throw WineDataManagerError.recommendListExpired
        }
        
        // ✅ 2. 추천 와인 리스트 가져오기
        guard let wineList = user.recommendWineList else {
            throw WineDataManagerError.recommendListNotFound
        }
        
        return wineList.wines
    }
    
    /// ✅ 만료된 추천 와인 데이터 삭제
    /// - Parameter userId: 삭제할 사용자 ID
    /// - Throws: 삭제 실패 시 예외 발생
    @MainActor
    public func deleteExpiredWineData(userId: Int) throws {
        let context = UserDataManager.shared.container.mainContext
        let user = try UserDataManager.shared.fetchUser(userId: userId)
        
        guard let wineList = user.recommendWineList else {
            print("⚠️ 삭제할 추천 와인 리스트가 없음 (유저: \(userId))")
            return
        }
        
        // ✅ 1. 만료된 데이터 확인 후 삭제 진행
        if wineList.timestamp < Date() {
            context.delete(wineList)
            user.recommendWineList = nil
            
            // ✅ 2. 변경 사항 저장 (안전하게 처리)
            do {
                try context.save()
                print("✅ 만료된 추천 와인 리스트 삭제 완료 (유저: \(userId))")
            } catch {
                print("❌ 추천 와인 리스트 삭제 중 오류 발생: \(error.localizedDescription)")
                throw WineDataManagerError.deleteFailed(reason: error.localizedDescription)
            }
        } else {
            print("⚠️ 삭제할 만료된 데이터가 없음 (유저: \(userId))")
        }
    }
    
    // MARK: - 내부 함수
    /// ✅ 추천 와인 리스트가 만료되었는지 확인
    /// - Parameters:
    ///   - userData: 확인할 사용자 데이터
    ///   - context: SwiftData 컨텍스트
    /// - Returns: 만료 여부 (`true`: 만료됨, `false`: 유효함)
    /// - Throws: 데이터 오류 발생 시 예외 처리
    private func isWineDataExpired(by userData: UserData, in context: ModelContext) throws -> Bool {
        guard let wineList = userData.recommendWineList else {
            return true // 데이터가 없으면 만료된 것으로 간주
        }
        
        return wineList.timestamp < Date()
    }
    
    /// ✅ 추천 와인 리스트 가져오기 (없으면 생성)
    /// - Parameters:
    ///   - userId: 사용자 ID
    ///   - context: SwiftData 컨텍스트
    /// - Returns: 추천 와인 리스트 (`RecommendWineList`)
    /// - Throws: 데이터 오류 발생 시 예외 처리
    @MainActor
    private func fetchOrCreateWineList(for userId: Int, in context: ModelContext) throws -> RecommendWineList {
        let user = try UserDataManager.shared.fetchUser(userId: userId)
        
        // ✅ 추천 와인 리스트가 존재하는 경우 반환
        if let existingList = user.recommendWineList {
            return existingList
        }
        
        // ✅ 없으면 새로 생성
        let newWineList = RecommendWineList(wines: [], timestamp: Date(), user: user)
        context.insert(newWineList)
        user.recommendWineList = newWineList
        
        return newWineList
    }
    
}

// MARK: - 에러 정의

/// WineDataManager 관련 오류 정의
public enum WineDataManagerError: Error {
    /// 사용자를 찾을 수 없음
    case userNotFound(userId: Int)
    /// 추천 와인 리스트를 찾을 수 없음
    case recommendListNotFound
    /// 추천 와인 리스트가 만료됨
    case recommendListExpired
    /// 데이터 저장 실패
    case saveFailed(reason: String)
    case deleteFailed(reason: String)
}

// MARK: - 에러 메시지 추가

extension WineDataManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .userNotFound(let userId):
            return "🚨 [오류] ID가 \(userId)인 사용자를 찾을 수 없습니다."
            
        case .recommendListNotFound:
            return "🚨 [오류] 추천 와인 리스트를 찾을 수 없습니다."
            
        case .recommendListExpired:
            return "🚨 [오류] 추천 와인 리스트가 만료되었습니다. 새 데이터를 요청하세요."
            
        case .saveFailed(let reason):
            return "🚨 [오류] 데이터를 저장하는데 실패하였습니다. 원인: \(reason)"
            
        case .deleteFailed(let reason):
            return "🚨 [오류] 데이터를 삭제하는데 실패하였습니다. 원인: \(reason)"
        }
    }
}
