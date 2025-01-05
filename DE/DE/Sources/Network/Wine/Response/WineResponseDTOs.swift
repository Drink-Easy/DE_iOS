// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct SearchWineResponseDTO: Decodable {
    public let wineId: Int
    public let name: String
    public let imageUrl : String
    public let sort: String
    public let area: String
    public let vivinoRating: Double
    public let price: Int
}

public struct WineResponseWithThreeReviewsDTO: Decodable {
    public let wineResponse: WineResponseDTO
    public let recentReviews: [WineReviewResponseDTO]?
}

public struct WineResponseDTO : Decodable {
    public let wineId: Int
    public let name: String
    public let imageUrl: String
    public let price: Int
    public let sort: String
    public let area: String
    public let variety: String?
    public let vivinoRating: Double
    public let avgSugarContent: Double
    public let avgAcidity: Double
    public let avgTannin: Double
    public let avgBody: Double
    public let avgAlcohol: Double
    public let wineNoteNose: WineNoteNose?
    public let avgMemberRating: Double
    public let liked: Bool
}

public struct WineNoteNose : Decodable {
    public let nose1 : String?
    public let nose2 : String?
    public let nose3 : String?
}

public struct WineReviewResponseDTO: Decodable {
    public let name: String?
    public let review: String?
    public let rating: Double?
    public let createdAt: String?
}

public struct HomeWineDTO : Decodable {
    public let wineId : Int
    public let imageUrl: String
    public let wineName: String
    public let sort : String
    public let price : Int
    public let vivinoRating: Double
}
