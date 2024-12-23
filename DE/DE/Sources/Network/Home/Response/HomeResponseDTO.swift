// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

struct HomeResponseDTO: Decodable {
    let name: String
    let recommendWineDTOs: [RecommendWineDTO]
}

struct RecommendWineDTO : Decodable {
    let wineId: Int
    let wineName: String
    let imageUrl: String
}
