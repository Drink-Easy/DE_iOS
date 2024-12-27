// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct WineWishlistRequestDTO : Codable {
    public let wineId : Int
    
    public init(wineId: Int) {
        self.wineId = wineId
    }
}
