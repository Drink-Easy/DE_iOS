// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import SwiftData

public final class WishlistDataManager {
    public static let shared = WishlistDataManager()
    let container: ModelContainer
    
    private init() {
        do {
            container = try ModelContainer(for: WineData.self, Wishlist.self)
        } catch {
            fatalError("SwiftData 초기화 실패: \(error.localizedDescription)")
        }
    }
    
    // MARK: - 위시리스트 조회
    @MainActor
    public func fetchWishlist() -> [WineData] {
        let context = container.mainContext
        let descriptor = FetchDescriptor<WishList>(
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
}
