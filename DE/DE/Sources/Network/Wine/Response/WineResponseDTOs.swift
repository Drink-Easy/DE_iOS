// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

struct SearchWineResponseDTO: Decodable {
    let wineId: Int
    let name: String
    let imageUrl : String
    let sort: String
    let area: String
    let satisfaction: Double
    let price: Int
    let liked: Bool
}

struct WineResponseWithThreeReviewsDTO: Decodable {
    let wineResponseDTO: WineResponseDTO
    let recentReviews: [WineReviewResponseDTO]
}

struct WineResponseDTO : Decodable {
    let wineId: Int
    let name: String
    let imageUrl: String
    let price: Int
    let sort: String
    let area: String
    let satisfaction: Double
    let avgSugarContent: Double
    let avgAcidity: Double
    let avgTanin: Double
    let avgBody: Double
    let avgAlcohol: Double
    let wineNoteNose: WineNoteNose
}

struct WineNoteNose : Decodable {
    let nose1 : String
    let nose2 : String
    let nose3 : String
}

struct WineReviewResponseDTO: Decodable {
    let name: String
    let review: String
    let satisfaction: Double
}
