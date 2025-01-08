// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct WinePreviewResponse : Decodable {
    public let wineId : Int
    public let name : String
    public let imageUrl : String
    public let sort : String
    public let area : String
    public let variety : String?
    public let vivinoRating : Double
    public let price : Int
    
    init(wineId: Int, name: String, imageUrl: String, sort: String, area: String, variety: String?, vivinoRating: Double, price: Int) {
        self.wineId = wineId
        self.name = name
        self.imageUrl = imageUrl
        self.sort = sort
        self.area = area
        self.variety = variety
        self.vivinoRating = vivinoRating
        self.price = price
    }
}
