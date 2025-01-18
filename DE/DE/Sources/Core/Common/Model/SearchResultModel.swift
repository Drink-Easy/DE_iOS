// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

public struct SearchResultModel {
    public let wineId: Int
    public let name: String
    public let nameEng: String
    public let imageUrl: String
    public let sort: String
    public let country: String
    public let region: String
    public let variety: String
    public let vivinoRating: Double
    public let price: Int
    
    public init(wineId: Int, name: String, nameEng: String, imageUrl: String, sort: String, country: String, region: String, variety: String, vivinoRating: Double, price: Int) {
        self.wineId = wineId
        self.name = name
        self.nameEng = nameEng
        self.imageUrl = imageUrl
        self.sort = sort
        self.country = country
        self.region = region
        self.variety = variety
        self.vivinoRating = vivinoRating
        self.price = price
    }
}
