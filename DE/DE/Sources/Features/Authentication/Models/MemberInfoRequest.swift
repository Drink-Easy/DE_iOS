// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

struct MemberInfoRequest : Codable {
    let name : String
    let isNewbie : Bool
    let monthPrice : Int
    let wineSort : [String]
    let wineArea : [String]
    let wineVariety : [String]
    let region : String
    
    init(isNewbie: Bool, monthPrice: Int, wineSort: [String], wineArea: [String], wineVariety: [String], region: String, name: String) {
        self.isNewbie = isNewbie
        self.monthPrice = monthPrice
        self.wineSort = wineSort
        self.wineArea = wineArea
        self.wineVariety = wineVariety
        self.region = region
        self.name = name
    }
}
