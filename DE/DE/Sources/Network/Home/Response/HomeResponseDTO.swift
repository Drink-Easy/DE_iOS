// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct HomeResponseDTO: Decodable {
    public let name: String
    public let recommendWineDTOs: [RecommendWineDTO]
}

public struct RecommendWineDTO : Decodable {
    public let wineId: Int
    public let wineName: String
    public let imageUrl: String
}
