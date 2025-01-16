// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

public struct MyOwnedWine {
    public var wineImg: String
    public var wineName: String
    public var price: String
    public var buyDate: String
    
    public init(wineImg: String = "", wineName: String = "", price: String = "", buyDate: String = "") {
        self.wineImg = wineImg
        self.wineName = wineName
        self.price = price
        self.buyDate = buyDate
    }
    
    // 업데이트 메서드
    public mutating func updateWine(wineImg: String? = nil, wineName: String? = nil, price: String? = nil, buyDate: String? = nil) {
        if let wineImg = wineImg { self.wineImg = wineImg }
        if let wineName = wineName { self.wineName = wineName }
        if let price = price { self.price = price }
        if let buyDate = buyDate { self.buyDate = buyDate }
    }
}


