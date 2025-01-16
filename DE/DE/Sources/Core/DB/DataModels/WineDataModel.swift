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
    @Attribute public var type: String
    @Relationship var wines: [WineData] = []
    var timestamp: Date // 캐시 유효기간 관리
    @Relationship var user: UserData? // 사용자 관계 (부모 관계)

    init(type: WineListType, wines: [WineData], timestamp: Date, user: UserData) {
        self.type = type.rawValue
        self.wines = wines
        self.timestamp = timestamp
        self.user = user
    }
}
