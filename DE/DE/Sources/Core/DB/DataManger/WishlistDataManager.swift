// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SwiftData

public final class WishlistDataManager {
    public static let shared = WishlistDataManager()
    
    lazy var container: ModelContainer = {
        do {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: false)
            let container = try ModelContainer(
                for: UserData.self, Wishlist.self, WineData.self,
                configurations: configuration
            )
            print("✅ SwiftData 초기화 성공!")
            return container
        } catch {
            print("❌ SwiftData 초기화 실패: \(error.localizedDescription)")
            fatalError("SwiftData 초기화 실패: \(error.localizedDescription)")
        }
    }()
    
    // MARK: - Methods
    /// 위시리스트 최초 생성 함수
    /// - 위시리스트 없으면 생성
    ///
    @MainActor
    public func createWishlistIfNeeded(for userId: Int, with newWines: [WineData]) async throws {
        let context = container.mainContext

        // 1. 사용자 확인
        let user = try fetchUser(by: userId, in: context)

        // 2. 위시리스트 존재 여부 확인
        if user.wishlist != nil {
            print("✅ 유저의 위시리스트가 이미 존재합니다.")
            return
        }

        // 3. 위시리스트 생성
        let newWishlist = Wishlist(wishlishWines: newWines, user: user) // 초기에는 빈 위시리스트
        user.wishlist = newWishlist // 유저 연결

        do {
            try context.save()
            print("✅ 새로운 위시리스트가 생성되었습니다.")
        } catch {
            throw WishlistError.saveFailed(reason: error.localizedDescription)
        }
    }
    
    /// 위시리스트 와인 목록 가져오기
    /// - 위시리스트 get api 호출 전 사용
    @MainActor
    public func fetchWishlist(for userId: Int) async throws -> [WineData] {
        let context = container.mainContext

        // 1. 사용자 확인
        let user = try fetchUser(by: userId, in: context)

        // 2. 위시리스트 확인
        guard let wishlist = user.wishlist else {
            throw WishlistError.userNotFound
        }

        // 3. 위시리스트의 WineData 반환
        return wishlist.wishlishWines
    }
    
    /// 위시리스트 와인 목록 업데이트
    /// - 위시리스트 get api 호출 후에만 사용
    @MainActor
    public func updateWishlist(for userId: Int, with newWines: [WineData]) async throws {
        let context = container.mainContext

        // 1. 사용자 확인
        let user = try fetchUser(by: userId, in: context)

        // 2. 위시리스트 확인
        guard let wishlist = user.wishlist else {
            throw WishlistError.userNotFound
        }

        // 3. 위시리스트 업데이트
        wishlist.wishlishWines = newWines

        // 4. 저장
        do {
            try context.save()
            print("✅ 위시리스트가 업데이트되었습니다. 새로운 와인: \(newWines.count)개")
        } catch {
            throw WishlistError.saveFailed(reason: error.localizedDescription)
        }
    }
    
    /// 위시리스트 삭제
    /// - 탈퇴할때? 언제불러야할까
    @MainActor
    public func deleteWishlist(for userId: Int) async throws {
        let context = container.mainContext

        // 1. 사용자 확인
        let user = try fetchUser(by: userId, in: context)

        // 2. 위시리스트 확인
        guard let wishlist = user.wishlist else {
            throw WishlistError.userNotFound
        }

        // 3. 위시리스트 삭제
        context.delete(wishlist)
        user.wishlist = nil // 유저와의 관계 해제

        // 4. 저장
        do {
            try context.save()
            print("✅ 위시리스트가 삭제되었습니다.")
        } catch {
            throw WishlistError.saveFailed(reason: error.localizedDescription)
        }
    }
    
    // MARK: - 내부 함수
    
    /// 유저 검증
    @MainActor
    private func fetchUser(by userId: Int, in context: ModelContext) throws -> UserData {
        let descriptor = FetchDescriptor<UserData>(predicate: #Predicate { $0.userId == userId })
        let users = try context.fetch(descriptor)
        
        guard let user = users.first else {
            throw WishlistError.userNotFound
        }
        
        return user
    }
}

public enum WishlistError: Error {
    case userNotFound
    case controllerAlreadyExists(name: String)
    case saveFailed(reason: String)
    case unknown
}

extension WishlistError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "사용자를 찾을 수 없습니다."
        case .controllerAlreadyExists(let name):
            return "The controller '\(name)' already exists for this user."
        case .saveFailed(let reason):
            return "데이터를 저장하는데 실패하였습니다. 원인: \(reason)"
        case .unknown:
            return "알 수 없는 에러가 발생했습니다."
        }
    }
}
