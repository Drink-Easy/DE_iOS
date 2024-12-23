// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

struct WineWishlistRequestDTO : Codable {
    let wineId : Int
    
    init(wineId: Int) {
        self.wineId = wineId
    }
}
