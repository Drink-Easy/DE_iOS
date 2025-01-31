// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SwiftData

public final class MyWineListDataManager {
    public static let shared = MyWineListDataManager()
    
    private init() {} // 싱글톤

    // MARK: - Methods
    
    /// ✅ 사용자에게 보유와인리스트가 없으면 생성 (이미 존재하면 업데이트)
    @MainActor
    public func createSavedWineListIfNeeded(for userId: Int, with newWines: [SavedWineDataModel], date: Date = Date()) async throws {
        let context = UserDataManager.shared.container.mainContext

        let user = try UserDataManager.shared.fetchUser(userId: userId)

        if user.savedWineList != nil {
            print("✅ \(userId) 유저의 보유와인리스트가 이미 존재합니다. 업데이트 실행.")
            
            do {
                try await updateSavedWinelist(for: userId, with: newWines, date: date)
            } catch {
                print("⚠️ 보유와인리스트 업데이트 중 오류 발생: \(error)")
            }
            return
        }

        let newWineList = MyWineList(wineList: newWines, timestamp: date, user: user)
        user.savedWineList = newWineList

        do {
            try context.save()
            print("✅ \(userId)의 새로운 보유와인리스트가 생성되었습니다.")
        } catch {
            throw MyWineListError.saveFailed(userId: userId, reason: error.localizedDescription)
        }
    }
    
    /// ✅ 사용자의 보유와인리스트를 가져오기
    @MainActor
    public func fetchSavedWinelist(for userId: Int) async throws -> [SavedWineDataModel] {
        let user = try UserDataManager.shared.fetchUser(userId: userId)

        guard let savedWineList = user.savedWineList else {
            throw MyWineListError.myWinelistNotFound(userId: userId)
        }

        return savedWineList.wineList
    }
    
    /// ✅ 보유와인리스트 업데이트
    @MainActor
    public func updateSavedWinelist(for userId: Int, with newWines: [SavedWineDataModel], date: Date = Date()) async throws {
        let context = UserDataManager.shared.container.mainContext

        let user = try UserDataManager.shared.fetchUser(userId: userId)

        guard let savedWineList = user.savedWineList else {
            throw MyWineListError.myWinelistNotFound(userId: userId)
        }

        savedWineList.wineList = newWines
        savedWineList.timestamp = date

        do {
            try context.save()
            print("✅ \(userId)의 보유와인 리스트가 업데이트되었습니다. 새로운 와인: \(newWines.count)개")
        } catch {
            throw MyWineListError.saveFailed(userId: userId, reason: error.localizedDescription)
        }
    }
    
    /// ✅ 만료된 보유와인리스트 초기화
    @MainActor
    public func clearExpiredWineList(for userId: Int) async throws {
        let context = UserDataManager.shared.container.mainContext

        let user = try UserDataManager.shared.fetchUser(userId: userId)

        guard let savedWineList = user.savedWineList else {
            throw MyWineListError.myWinelistNotFound(userId: userId)
        }

        let today = Calendar.current.startOfDay(for: Date())

        // timestamp가 없거나, 오늘 날짜보다 이전이면 초기화
        if savedWineList.timestamp == nil || savedWineList.timestamp! < today {
            savedWineList.wineList = []
            savedWineList.timestamp = nil

            do {
                try context.save()
                print("✅ \(userId)의 만료된 보유와인리스트가 초기화되었습니다.")
            } catch {
                throw MyWineListError.saveFailed(userId: userId, reason: error.localizedDescription)
            }
        } else {
            print("✅ \(userId)의 보유와인리스트는 여전히 유효합니다.")
        }
    }
    
    /// ✅ 보유와인리스트 삭제
    @MainActor
    public func deleteSavedWinelist(for userId: Int) async throws {
        let context = UserDataManager.shared.container.mainContext

        let user = try UserDataManager.shared.fetchUser(userId: userId)

        guard let myWineList = user.savedWineList else {
            throw MyWineListError.myWinelistNotFound(userId: userId)
        }

        context.delete(myWineList)
        user.savedWineList = nil

        do {
            try context.save()
            print("✅ \(userId)의 보유와인리스트가 삭제되었습니다.")
        } catch {
            throw MyWineListError.saveFailed(userId: userId, reason: error.localizedDescription)
        }
    }
}

// MARK: - 에러 정의

public enum MyWineListError: Error {
    /// 사용자를 찾을 수 없는 경우.
    case userNotFound(userId: Int)
    
    /// 사용자의 보유와인리스트가 없는 경우.
    case myWinelistNotFound(userId: Int)
    
    /// 데이터를 저장하는 데 실패한 경우.
    case saveFailed(userId: Int, reason: String)
    
    /// 알 수 없는 에러.
    case unknown
}

extension MyWineListError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .userNotFound(let userId):
            return "🚨 [오류] ID가 \(userId)인 사용자를 찾을 수 없습니다. 회원가입 여부를 확인하세요!"
            
        case .myWinelistNotFound(let userId):
            return "🚨 [오류] ID가 \(userId)인 사용자의 보유와인리스트를 찾을 수 없습니다."
            
        case .saveFailed(let userId, let reason):
            return "🚨 [오류] ID가 \(userId)인 사용자의 보유와인리스트 저장 실패. 이유: \(reason)"
            
        case .unknown:
            return "🚨 [오류] 알 수 없는 에러가 발생했습니다."
        }
    }
}
