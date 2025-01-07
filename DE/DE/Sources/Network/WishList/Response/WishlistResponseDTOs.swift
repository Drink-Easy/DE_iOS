// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct WinePreviewResponse : Decodable {
    let wineId : Int
    let name : String
    let imageUrl : String
    let sort : String
    let area : String
    let variety : String
    let viviniRating : Double
    let price : Int
}
