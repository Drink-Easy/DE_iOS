// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

public struct WishResultModel {
    public let wineId: Int
    public let imageUrl: String
    public let wineName: String
    public let sort: String
    public let price: Int
    public let vivinoRating: Double
    
    public init(wineId: Int, imageUrl: String, wineName: String, sort: String, price: Int, vivinoRating: Double) {
        self.wineId = wineId
        self.imageUrl = imageUrl
        self.wineName = wineName
        self.sort = sort
        self.price = price
        self.vivinoRating = vivinoRating
    }
}

