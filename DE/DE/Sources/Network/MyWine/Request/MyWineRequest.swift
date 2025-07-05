// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct MyWineRequest: Codable {
    public var wineId: Int
    public var vintageYear: Int?
    public var purchaseDate : String
    public var purchasePrice : Int?
    
    init(wineId: Int, vintageYear: Int? = nil, purchaseDate: String, purchasePrice: Int? = nil) {
        self.wineId = wineId
        self.vintageYear = vintageYear
        self.purchaseDate = purchaseDate
        self.purchasePrice = purchasePrice
    }
}

public struct MyWineUpdateRequest: Codable {
    public var vintageYear: Int?
    public var purchaseDate : String?
    public var purchasePrice : Int?
    
    init(vintageYear: Int? = nil, purchaseDate: String? = nil, purchasePrice: Int? = nil) {
        self.vintageYear = vintageYear
        self.purchaseDate = purchaseDate
        self.purchasePrice = purchasePrice
    }
}

