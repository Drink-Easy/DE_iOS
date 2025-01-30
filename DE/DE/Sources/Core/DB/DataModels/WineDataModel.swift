// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import SwiftData

public enum WineListType: String, Codable {
    case recommended = "recommended"
    case popular = "popular"
}

/// 와인 데이터 모델
@Model
public class WineData {
    /// 와인 고유 ID
    public var wineId: Int
    /// 와인 이미지 URL
    public var imageUrl: String
    /// 와인 이름
    public var wineName: String
    /// 와인 종류 (예: 레드, 화이트)
    public var sort: String
    /// 와인 가격 (단위: 원)
    public var price: Int
    /// Vivino 와인 평점
    public var vivinoRating: Double
    
    /// 와인 데이터 초기화
    /// - Parameters:
    ///   - wineId: 와인 고유 ID
    ///   - imageUrl: 와인 이미지 URL
    ///   - wineName: 와인 이름
    ///   - sort: 와인 종류 (레드, 화이트 등)
    ///   - price: 와인 가격
    ///   - vivinoRating: Vivino 와인 평점
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
    @Attribute var timestamp: Date // 캐시 유효기간 관리
    @Relationship var user: UserData? // 사용자 관계 (부모 관계)

    init(type: WineListType, wines: [WineData], timestamp: Date, user: UserData) {
        self.type = type.rawValue
        self.wines = wines
        self.timestamp = timestamp
        self.user = user
    }
}


/// 인기 와인 목록 모델
@Model
public class PopularWineList {
    /// 저장된 와인 목록
    @Relationship var wines: [WineData] = []
    /// 데이터 유효기간 관리 (만료 시 데이터 삭제)
    @Attribute var timestamp: Date

    /// 인기 와인 목록 초기화
    /// - Parameters:
    ///   - wines: 저장할 와인 목록
    ///   - timestamp: 데이터 유효기간
    public init(wines: [WineData], timestamp: Date) {
        self.wines = wines
        self.timestamp = timestamp
    }
}
