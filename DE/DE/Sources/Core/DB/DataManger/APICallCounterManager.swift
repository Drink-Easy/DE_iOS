// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import SwiftData

public final class APICallCounterManager {
    public static let shared = APICallCounterManager()
    
    lazy var container: ModelContainer = {
        do {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
            let container = try ModelContainer(
                for: UserData.self, APIControllerCounter.self, APICounter.self
            )
            print("✅ SwiftData 초기화 성공!")
            return container
        } catch {
            print("❌ SwiftData 초기화 실패: \(error.localizedDescription)")
            fatalError("SwiftData 초기화 실패: \(error.localizedDescription)")
        }
    }()
    
    /// 새로운 APICounter 생성 및 저장
    @MainActor
    public func createAPIControllerCounter(
        for userId: Int,
        controllerName: String
    ) async throws {
        let context = container.mainContext

        // 1. 사용자 검색
        let descriptor = FetchDescriptor<UserData>(predicate: #Predicate { $0.userId == userId })
        let users = try context.fetch(descriptor)

        guard let user = users.first else {
            throw APICallCounterError.userNotFound
        }

        // 2. 중복 컨트롤러 검사
        if user.controllerCounters.contains(where: { $0.name == controllerName }) {
            throw APICallCounterError.controllerAlreadyExists(name: controllerName)
        }

        // 3. 새로운 APICounter 및 APIControllerCounter 생성
        let apiCounter = APICounter()
        let controllerCounter = APIControllerCounter(name: controllerName, counter: apiCounter, user: user)
        user.controllerCounters.append(controllerCounter)

        // 4. 저장
        do {
            try context.save()
            print("✅ APIControllerCounter \(controllerName) 생성 및 저장 완료!")
        } catch {
            throw APICallCounterError.saveFailed(reason: error.localizedDescription)
        }
    }
    
    
}


public enum APICallCounterError: Error {
    case userNotFound
    case controllerAlreadyExists(name: String)
    case saveFailed(reason: String)
    case unknown
}

extension APICallCounterError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "User not found."
        case .controllerAlreadyExists(let name):
            return "The controller '\(name)' already exists for this user."
        case .saveFailed(let reason):
            return "Failed to save data. Reason: \(reason)"
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
