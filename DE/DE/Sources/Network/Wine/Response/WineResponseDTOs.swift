// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct SearchWineResponseDTO: Decodable {
    public let wineId: Int
    public let name: String
    public let nameEng: String
    public let imageUrl : String
    public let sort: String
    public let country: String
    public let region: String
    public let variety: String
    public let vivinoRating: Double
    public let price: Int
}

public struct PageSearchWineResponseDTO : Decodable {
    public let content : [SearchWineResponseDTO]?
    public let pageNumber : Int
    public let totalPages : Int
}

public struct WineResponseWithThreeReviewsDTO: Decodable {
    public let wineInfoResponse: WineResponseDTO
    public let recentReviews: [WineReviewResponseDTO]?
}

public struct WineResponseDTO : Decodable {
    public let wineId: Int
    public let name: String
    public let nameEng: String
    public let imageUrl: String
    public let price: Int
    public let sort: String
    public let country: String
    public let region: String
    public let variety: String
    public let vivinoRating: Double
    public let avgSweetness: Double
    public let avgAcidity: Double
    public let avgTannin: Double
    public let avgBody: Double
    public let avgAlcohol: Double
    public let nose1 : String?
    public let nose2 : String?
    public let nose3 : String?
    public let avgMemberRating: Double
    public let liked: Bool
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

public struct PageResponseWineReviewResponse : Decodable {
    public let content : [WineReviewResponseDTO]?
    public let pageNumber : Int
    public let totalPages : Int
}
