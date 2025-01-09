// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct MyWineRequest: Codable {
    public var wineId: Int
    public var purchaseData : String
    public var purchasePrice : Int
    
    init(wineId: Int, purchaseData: String, purchasePrice: Int) {
        self.wineId = wineId
        self.purchaseData = purchaseData
        self.purchasePrice = purchasePrice
    }
}

public struct MyWineUpdateRequest: Codable {
    public var purchaseData : String?
    public var purchasePrice : Int?
    
    init(purchaseData: String? = nil, purchasePrice: Int? = nil) {
        self.purchaseData = purchaseData
        self.purchasePrice = purchasePrice
    }
}

