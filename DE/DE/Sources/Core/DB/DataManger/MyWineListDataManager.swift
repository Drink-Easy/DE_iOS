// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SwiftData

public final class MyWineListDataManager {
    public static let shared = MyWineListDataManager()
    
    lazy var container: ModelContainer = {
        do {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
            let container = try ModelContainer(
                for: UserData.self, MyWineList.self, SavedWineDataModel.self,
                configurations: configuration
            )
            print("✅ 보유와인 SwiftData 초기화 성공!")
            return container
        } catch {
            print("❌ SwiftData 초기화 실패: \(error.localizedDescription)")
            fatalError("SwiftData 초기화 실패: \(error.localizedDescription)")
        }
    }()
    
    // MARK: - Methods
    
    /// 사용자에게 보유와인리스트가 없는 경우 새로 생성합니다.
    /// - Parameters:
    ///   - userId: 보유와인 리스트를 생성할 사용자의 ID.
    ///   - newWines: 초기 보유와인 리스트에 저장할 와인 데이터 배열.
    /// - Throws:
    ///   - `MyWineListError.userNotFound`: 사용자를 찾을 수 없는 경우.
    ///   - `MyWineListError.saveFailed`: 리스트 저장에 실패한 경우.
    @MainActor
    public func createSavedWineListIfNeeded(for userId: Int, with newWines: [SavedWineDataModel], date: Date = Date()) async throws {
        let context = container.mainContext

        let user = try fetchUser(by: userId, in: context)

        if user.savedWineList != nil {
            print("✅ \(userId) 유저의 보유와인리스트가 이미 존재합니다.")
            print("✅ \(userId) 유저의 보유와인리스트를 업데이트합니다.")
            
            do {
                try await self.updateSavedWinelist(for: userId, with: newWines, date: date)
            } catch {
                print("⚠️ 보유와인리스트 업데이트 중 오류 발생: \(error)")
            }
            return
        }

        let newWineList = MyWineList(wineList: newWines, timestamp: date, user: user)
        user.savedWineList = newWineList // 유저 연결

        do {
            try context.save()
            print("✅ \(userId)의 새로운 보유와인리스트가 생성되었습니다.")
        } catch {
            throw MyWineListError.saveFailed(reason: error.localizedDescription)
        }
    }
    
    /// 사용자의 보유와인리스트에 저장된 와인 데이터를 가져옵니다.
    /// - Parameter userId: 보유와인리스트를 가져올 사용자의 ID.
    /// - Returns: 보유와인리스트에 저장된 `SavedWineDataModel` 배열.
    /// - Throws:
    ///   - `MyWineListError.userNotFound`: 사용자를 찾을 수 없는 경우.
    ///   - `MyWineListError.myWinelistNotFound`: 사용자의 보유와인리스트가 없는 경우.
    @MainActor
    public func fetchSavedWinelist(for userId: Int) async throws -> [SavedWineDataModel] {
        let context = container.mainContext

        let user = try fetchUser(by: userId, in: context)

        guard let savedWineList = user.savedWineList else {
            throw MyWineListError.myWinelistNotFound
        }

        return savedWineList.wineList
    }
    
    /// 사용자의 보유와인리스트를 새로운 와인 데이터로 업데이트합니다.
    /// - Parameters:
    ///   - userId: 보유와인리스트를 업데이트할 사용자의 ID.
    ///   - newWines: 새로운 와인 데이터 배열.
    ///   - date: 업데이트 날짜.(하루가 지나면 폐기)
    /// - Throws:
    ///   - `MyWineListError.userNotFound`: 사용자를 찾을 수 없는 경우.
    ///   - `MyWineListError.myWinelistNotFound`: 사용자의 보유와인리스트가 없는 경우.
    ///   - `MyWineListError.saveFailed`: 보유와인리스트 저장에 실패한 경우.
    @MainActor
    public func updateSavedWinelist(for userId: Int, with newWines: [SavedWineDataModel], date: Date = Date()) async throws {
        let context = container.mainContext

        let user = try fetchUser(by: userId, in: context)

        guard let savedWineList = user.savedWineList else {
            throw MyWineListError.myWinelistNotFound
        }

        savedWineList.wineList = newWines

        do {
            try context.save()
            print("✅ \(userId)의 보유와인 리스트가 업데이트되었습니다. 새로운 와인: \(newWines.count)개")
        } catch {
            throw MyWineListError.saveFailed(reason: error.localizedDescription)
        }
    }
    
    /// 와인리스트가 만료되었는지 확인하고, 만료된 경우 초기화하는 함수.
    /// - Parameter userId: 확인할 사용자의 ID.
    /// - Throws:
    ///   - `MyWineListError.userNotFound`: 사용자를 찾을 수 없는 경우.
    ///   - `MyWineListError.myWinelistNotFound`: 사용자의 보유와인리스트가 없는 경우.
    ///   - `MyWineListError.saveFailed`: 보유와인리스트 초기화 저장에 실패한 경우.
    @MainActor
    public func clearExpiredWineList(for userId: Int) async throws {
        let context = container.mainContext

        // 1. 사용자 확인
        let user = try fetchUser(by: userId, in: context)

        // 2. 보유와인리스트 확인
        guard let savedWineList = user.savedWineList else {
            throw MyWineListError.myWinelistNotFound
        }

        // 3. 날짜 확인
        guard let listDate = savedWineList.timestamp, listDate < Calendar.current.startOfDay(for: Date()) else {
            // 아예 00:00:00 으로 초기화해서 비교
            print("✅ 와인리스트가 만료되지 않았습니다.")
            return
        }

        // 4. 와인리스트 초기화
        savedWineList.wineList = []
        savedWineList.timestamp = nil

        // 5. 저장
        do {
            try context.save()
            print("✅ \(userId)의 만료된 보유와인리스트가 초기화되었습니다.")
        } catch {
            throw MyWineListError.saveFailed(reason: error.localizedDescription)
        }
    }
    
    /// 사용자의 보유와인 리스트를 삭제합니다.
    /// - Parameter userId: 보유와인 리스트를 삭제할 사용자의 ID.
    /// - Throws:
    ///   - `MyWineListError.userNotFound`: 사용자를 찾을 수 없는 경우.
    ///   - `MyWineListError.myWinelistNotFound`: 사용자의 위시리스트가 없는 경우.
    ///   - `MyWineListError.saveFailed`: 위시리스트 삭제에 실패한 경우.
    @MainActor
    public func deleteSavedWinelist(for userId: Int) async throws {
        let context = container.mainContext

        // 1. 사용자 확인
        let user = try fetchUser(by: userId, in: context)

        // 2. 위시리스트 확인
        guard let myWineList = user.savedWineList else {
            throw MyWineListError.myWinelistNotFound
        }

        // 3. 위시리스트 삭제
        context.delete(myWineList)
        user.savedWineList = nil // 유저와의 관계 해제

        // 4. 저장
        do {
            try context.save()
            print("✅ 위시리스트가 삭제되었습니다.")
        } catch {
            throw MyWineListError.saveFailed(reason: error.localizedDescription)
        }
    }
    
    // MARK: - 내부 함수
    
    /// 사용자를 검색하여 반환합니다.
    /// - Parameters:
    ///   - userId: 검색할 사용자의 ID.
    ///   - context: SwiftData의 컨텍스트 객체.
    /// - Returns: `UserData` 객체.
    /// - Throws:
    ///   - `MyWineListError.userNotFound`: 사용자를 찾을 수 없는 경우.
    @MainActor
    private func fetchUser(by userId: Int, in context: ModelContext) throws -> UserData {
        let descriptor = FetchDescriptor<UserData>(predicate: #Predicate { $0.userId == userId })
        let users = try context.fetch(descriptor)
        
        guard let user = users.first else {
            throw MyWineListError.userNotFound
        }
        
        return user
    }
}

public enum MyWineListError: Error {
    /// 사용자를 찾을 수 없는 경우.
    case userNotFound
    
    /// 사용자의 위시리스트가 없는 경우.
    case myWinelistNotFound
    
    /// 데이터를 저장하는 데 실패한 경우.
    case saveFailed(reason: String)
    
    /// 알 수 없는 에러.
    case unknown
}

extension MyWineListError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "사용자를 찾을 수 없습니다."
        case .myWinelistNotFound:
            return "사용자의 보유와인리스트가 존재하지 않습니다."
        case .saveFailed(let reason):
            return "데이터를 저장하는 데 실패하였습니다. 이유: \(reason)"
        case .unknown:
            return "알 수 없는 에러가 발생했습니다."
        }
    }
}
