// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import SwiftData

public final class APICallCounterManager {
    public static let shared = APICallCounterManager()
    
    private init() {} // 싱글톤

    // MARK: - 내부 함수
    
    /// ✅ 특정 엔드포인트의 컨트롤러 검색
    @MainActor
    private func fetchController(for user: UserData, controllerName: EndpointType) throws -> APIControllerCounter {
        guard let controller = user.controllerCounters.first(where: { $0.name == controllerName.rawValue }) else {
            throw APICallCounterError.controllerNotExists(name: controllerName.rawValue)
        }
        return controller
    }
    
    /// ✅ API 호출 카운트 증가 (POST/PATCH/DELETE)
    @MainActor
    private func incrementCount(
        for userId: Int,
        controllerName: EndpointType,
        incrementAction: (APICounter) -> Void
    ) async throws {
        let context = UserDataManager.shared.container.mainContext

        let user = try UserDataManager.shared.fetchUser(userId: userId)
        let controller = try fetchController(for: user, controllerName: controllerName)

        incrementAction(controller.counter)

        do {
            try context.save()
            print("✅ \(controllerName.rawValue) 카운트 증가 완료!")
        } catch {
            throw APICallCounterError.saveFailed(reason: error.localizedDescription)
        }
    }
    
    //MARK: - 실제 호출하는 함수
    
    /// ✅ 새로운 API 컨트롤러 카운터 생성 (최초 호출 시 1회)
    @MainActor
    public func createAPIControllerCounter(
        for userId: Int,
        controllerName: EndpointType
    ) async throws {
        let context = UserDataManager.shared.container.mainContext
        let user = try UserDataManager.shared.fetchUser(userId: userId)

        // 이미 존재하는지 확인 후 중복 추가 방지
        if user.controllerCounters.contains(where: { $0.name == controllerName.rawValue }) {
            print("⚠️ \(controllerName.rawValue) 엔드포인트가 이미 존재합니다.")
            return
        }

        let apiCounter = APICounter()
        let controllerCounter = APIControllerCounter(name: controllerName, counter: apiCounter, user: user)
        user.controllerCounters.append(controllerCounter)

        do {
            try context.save()
            print("✅ \(controllerName.rawValue) 컨트롤러 카운터 생성 완료!")
        } catch {
            throw APICallCounterError.saveFailed(reason: error.localizedDescription)
        }
    }
    
    /// ✅ POST 호출 카운트 증가
    @MainActor
    public func incrementPost(for userId: Int, controllerName: EndpointType) async throws {
        try await incrementCount(for: userId, controllerName: controllerName) { $0.incrementPost() }
    }
    
    /// ✅ PATCH 호출 카운트 증가
    @MainActor
    public func incrementPatch(for userId: Int, controllerName: EndpointType) async throws {
        try await incrementCount(for: userId, controllerName: controllerName) { $0.incrementPatch() }
    }
    
    /// ✅ DELETE 호출 카운트 증가
    @MainActor
    public func incrementDelete(for userId: Int, controllerName: EndpointType) async throws {
        try await incrementCount(for: userId, controllerName: controllerName) { $0.incrementDelete() }
    }
    
    /// ✅ 특정 엔드포인트의 호출 카운트가 0인지 확인
    @MainActor
    public func isCallCountZero(for userId: Int, controllerName: EndpointType) async throws -> Bool {
        let user = try UserDataManager.shared.fetchUser(userId: userId)
        let controller = try fetchController(for: user, controllerName: controllerName)

        let counter = controller.counter
        return counter.postCount == 0 && counter.deleteCount == 0 && counter.patchCount == 0
    }
    
    /// ✅ 특정 엔드포인트의 호출 카운트 초기화
    @MainActor
    public func resetCallCount(for userId: Int, controllerName: EndpointType) async throws {
        let context = UserDataManager.shared.container.mainContext

        let user = try UserDataManager.shared.fetchUser(userId: userId)
        let controller = try fetchController(for: user, controllerName: controllerName)

        controller.counter.postCount = 0
        controller.counter.deleteCount = 0
        controller.counter.patchCount = 0

        do {
            try context.save()
            print("✅ \(controllerName.rawValue) API 호출 카운트 초기화 완료!")
        } catch {
            throw APICallCounterError.saveFailed(reason: error.localizedDescription)
        }
    }
}

// MARK: - 에러 정의

public enum APICallCounterError: Error {
    /// 해당 컨트롤러가 존재하지 않음
    case controllerNotExists(name: String)
    
    /// 데이터를 저장하는 데 실패한 경우
    case saveFailed(reason: String)
}

extension APICallCounterError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .controllerNotExists(let name):
            return "🚨 [오류] \(name) 엔드포인트에 대한 API 카운터가 존재하지 않습니다. 먼저 `createAPIControllerCounter`를 호출하세요."
            
        case .saveFailed(let reason):
            return "🚨 [오류] API 호출 카운트 저장 실패. 원인: \(reason)"
        }
    }
}
