// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import SwiftData

public enum WineListType: String, Codable {
    case recommended = "recommended"
    case popular = "popular"
}

@Model // SwiftData 모델 선언
public class WineData {
    public var wineId: Int
    public var imageUrl: String
    public var wineName: String
    public var sort: String
    public var price: Int
    public var vivinoRating: Double

    public init(wineId: Int, imageUrl: String, wineName: String, sort: String, price: Int, vivinoRating: Double) {
        self.wineId = wineId
        self.imageUrl = imageUrl
        self.wineName = wineName
        self.sort = sort
        self.price = price
        self.vivinoRating = vivinoRating
    }
}

@Model
public class WineList {
    var type: String // 추천 또는 인기 구분
    var wines : [WineData] = []
    
    public init(type: String) {
        self.type = type
    }
}
