// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct MyWineRequest: Codable {
    public var wineId: Int
    public var purchaseDate : String
    public var purchasePrice : Int
    
    init(wineId: Int, purchaseDate: String, purchasePrice: Int) {
        self.wineId = wineId
        self.purchaseDate = purchaseDate
        self.purchasePrice = purchasePrice
    }
}

public struct MyWineUpdateRequest: Codable {
    public var purchaseDate : String?
    public var purchasePrice : Int?
    
    init(purchaseDate: String? = nil, purchasePrice: Int? = nil) {
        self.purchaseDate = purchaseDate
        self.purchasePrice = purchasePrice
    }
}

