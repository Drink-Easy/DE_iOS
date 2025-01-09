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

        // 1. 사용자 검색 : 현재 로그인한 유저를 디비에서 찾기
        let descriptor = FetchDescriptor<UserData>(predicate: #Predicate { $0.userId == userId })
        let users = try context.fetch(descriptor)

        guard let user = users.first else {
            throw APICallCounterError.userNotFound
        }

        // 2. 중복 컨트롤러 검사 : 현재 counting하는 컨트롤러 종류 찾기
        if user.controllerCounters.contains(where: { $0.name == controllerName }) {
            throw APICallCounterError.controllerAlreadyExists(name: controllerName)
        }

        // 3. 새로운 APICounter 및 APIControllerCounter 생성 : 없으면 새로 생성
        let apiCounter = APICounter()
        let controllerCounter = APIControllerCounter(name: controllerName, counter: apiCounter, user: user)
        user.controllerCounters.append(controllerCounter)

        // 4. 저장 : 저장하기 - 초기값은 모두 0
        do {
            try context.save()
            print("✅ APIControllerCounter \(controllerName) 생성 및 저장 완료!")
        } catch {
            throw APICallCounterError.saveFailed(reason: error.localizedDescription)
        }
    }
    
    /// 유저 검증
    @MainActor
    private func fetchUser(by userId: Int, in context: ModelContext) throws -> UserData {
        let descriptor = FetchDescriptor<UserData>(predicate: #Predicate { $0.userId == userId })
        let users = try context.fetch(descriptor)
        
        guard let user = users.first else {
            throw APICallCounterError.userNotFound
        }
        
        return user
    }
    
    /// API Endpoint 검증
    @MainActor
    private func fetchController(for user: UserData, controllerName: String) throws -> APIControllerCounter {
        guard let controller = user.controllerCounters.first(where: { $0.name == controllerName }) else {
            throw APICallCounterError.controllerAlreadyExists(name: controllerName)
        }
        return controller
    }
    
    /// 카운트 증가
    @MainActor
    private func incrementCount(
        for userId: Int,
        controllerName: String,
        incrementAction: (APICounter) -> Void
    ) async throws {
        let context = container.mainContext
        
        // 1. 사용자 검색
        let user = try fetchUser(by: userId, in: context)
        
        // 2. 컨트롤러 검색
        let controller = try fetchController(for: user, controllerName: controllerName)
        
        // 3. 카운트 증가
        incrementAction(controller.counter)
        
        // 4. 저장
        do {
            try context.save()
            print("✅ \(controllerName)의 카운트 증가 및 저장 완료!")
        } catch {
            throw APICallCounterError.saveFailed(reason: error.localizedDescription)
        }
    }
    
    //MARK: -  실제 호출하는 함수
    
    /// POST 호출 카운트 증가
    @MainActor
    public func incrementPost(for userId: Int, controllerName: String) async throws {
        try await incrementCount(for: userId, controllerName: controllerName) { counter in
            counter.incrementPost()
        }
    }
    
    /// PATCH 호출 카운트 증가
    @MainActor
    public func incrementPatch(for userId: Int, controllerName: String) async throws {
        try await incrementCount(for: userId, controllerName: controllerName) { counter in
            counter.incrementPatch()
        }
    }
    
    /// DELETE 호출 카운트 증가
    @MainActor
    public func incrementDelete(for userId: Int, controllerName: String) async throws {
        try await incrementCount(for: userId, controllerName: controllerName) { counter in
            counter.incrementDelete()
        }
    }
    
    /// 호출 카운트 조회
    @MainActor
    public func isCallCountZero(for userId: Int, controllerName: String) async throws -> Bool {
        let context = container.mainContext

        // 1. 사용자 검색
        let user = try fetchUser(by: userId, in: context)
        
        // 2. 컨트롤러 검색
        let controller = try fetchController(for: user, controllerName: controllerName)
        
        // 3. 호출 카운트 확인
        let counter = controller.counter
        return counter.postCount == 0 && counter.deleteCount == 0 && counter.patchCount == 0
    }
    
    /// 호출 카운트 초기화
    @MainActor
    public func resetCallCount(for userId: Int, controllerName: String) async throws {
        let context = container.mainContext

        // 1. 사용자 검색
        let user = try fetchUser(by: userId, in: context)
        
        // 2. 컨트롤러 검색
        let controller = try fetchController(for: user, controllerName: controllerName)
        
        // 3. 호출 카운트 초기화
        let counter = controller.counter
        counter.postCount = 0
        counter.deleteCount = 0
        counter.patchCount = 0

        // 4. 저장
        do {
            try context.save()
            print("✅ \(controllerName)의 API 호출 카운트가 초기화되었습니다.")
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
            return "사용자를 찾을 수 없습니다."
        case .controllerAlreadyExists(let name):
            return "The controller '\(name)' already exists for this user."
        case .saveFailed(let reason):
            return "Failed to save data. Reason: \(reason)"
        case .unknown:
            return "An unknown error occurred."
        }
    }
}
