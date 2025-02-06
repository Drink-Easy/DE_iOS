// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SwiftData

public final class WishlistDataManager {
    public static let shared = WishlistDataManager()
    
    private init() {} // 싱글톤
    
    // MARK: - Methods
    
    /// ✅ 위시리스트가 없으면 새로 생성하는 메서드
    @MainActor
    public func createWishlistIfNeeded(for userId: Int, with newWines: [WishResultModel]) async throws {
        let context = UserDataManager.shared.container.mainContext
        
        // 1. 사용자 확인
        let user = try UserDataManager.shared.fetchUser(userId: userId)
        
        // 2. 위시리스트 존재 여부 확인
        if user.wishlist != nil {
            print("✅ \(userId)의 위시리스트가 이미 존재합니다.")
            return
        }

        // 3. 위시리스트 생성
        let newWishlist = Wishlist(wishlishWines: [], user: user)
        if !newWines.isEmpty {
            for data in newWines {
                let newWine = WineData(wineId: data.wineId, imageUrl: data.imageUrl, wineName: data.wineName, sort: data.sort, price: data.price, vivinoRating: data.vivinoRating)
                context.insert(newWine)
                newWishlist.wishlishWines.append(newWine)
            }
        }
        user.wishlist = newWishlist // 유저와 연결

        // 4. 저장
        do {
            try context.save()
            print("✅ \(userId)의 새로운 위시리스트가 생성되었습니다.")
        } catch {
            throw WishlistError.saveFailed(reason: error.localizedDescription)
        }
    }
    
    /// ✅ 사용자의 위시리스트를 가져오는 메서드
    @MainActor
    public func fetchWishlist(for userId: Int) async throws -> [WineData] {
        let context = UserDataManager.shared.container.mainContext

        // 1. 사용자 확인
        let user = try UserDataManager.shared.fetchUser(userId: userId)

        // 2. 위시리스트 확인
        guard let wishlist = user.wishlist else {
            throw WishlistError.wishlistNotFound
        }

        return wishlist.wishlishWines
    }
    
    /// ✅ 사용자의 위시리스트를 업데이트하는 메서드
    @MainActor
    public func updateWishlist(for userId: Int, with newWines: [WineData]) async throws {
        let context = UserDataManager.shared.container.mainContext

        // 1. 사용자 확인
        let user = try UserDataManager.shared.fetchUser(userId: userId)

        // 2. 위시리스트 확인
        guard let wishlist = user.wishlist else {
            throw WishlistError.wishlistNotFound
        }

        // 3. 업데이트
        if !newWines.isEmpty {
            wishlist.wishlishWines = newWines
        }

        // 4. 저장
        do {
            try context.save()
            print("✅ \(userId)의 위시리스트가 업데이트되었습니다. 새로운 와인: \(newWines.count)개")
        } catch {
            throw WishlistError.saveFailed(reason: error.localizedDescription)
        }
    }
    
    /// ✅ 사용자의 위시리스트를 삭제하는 메서드
    @MainActor
    public func deleteWishlist(for userId: Int) async throws {
        let context = UserDataManager.shared.container.mainContext

        // 1. 사용자 확인
        let user = try UserDataManager.shared.fetchUser(userId: userId)

        // 2. 위시리스트 확인
        guard let wishlist = user.wishlist else {
            throw WishlistError.wishlistNotFound
        }

        // 3. 삭제
        context.delete(wishlist)
        user.wishlist = nil // 유저와의 관계 해제

        // 4. 저장
        do {
            try context.save()
            print("✅ \(userId)의 위시리스트가 삭제되었습니다.")
        } catch {
            throw WishlistError.saveFailed(reason: error.localizedDescription)
        }
    }

}

// MARK: - 에러 정의

public enum WishlistError: Error {
    /// 사용자를 찾을 수 없는 경우.
    case userNotFound(userId: Int)
    
    /// 사용자의 위시리스트가 없는 경우.
    case wishlistNotFound
    
    /// 데이터를 저장하는 데 실패한 경우.
    case saveFailed(reason: String)
    
    /// 알 수 없는 에러.
    case unknown
}

extension WishlistError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .userNotFound(let userId):
            return "🚨 [오류] ID가 \(userId)인 사용자를 찾을 수 없습니다. 회원가입 여부를 확인하세요!"
            
        case .wishlistNotFound:
            return "🚨 [오류] 사용자의 위시리스트를 찾을 수 없습니다."
            
        case .saveFailed(let reason):
            return "🚨 [오류] 데이터를 저장하는 데 실패하였습니다. 이유: \(reason)"
            
        case .unknown:
            return "🚨 [오류] 알 수 없는 에러가 발생했습니다."
        }
    }
}
