// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
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
    
    // fetch
    
    // create
    
    // delete
    
}
