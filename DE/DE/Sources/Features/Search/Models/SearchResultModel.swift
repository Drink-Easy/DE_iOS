// Copyright © 2024 DRINKIG. All rights reserved

import UIKit


struct SearchResultModel {
    let wineId: Int
    let wineName: String
    let imageURL: String
    let sort: String
    let area: String
    let satisfaction: Double
    
    init(wineId: Int, wineName: String, imageURL: String, sort: String, area: String, satisfaction: Double) {
        self.wineId = wineId
        self.wineName = wineName
        self.imageURL = imageURL
        self.sort = sort
        self.area = area
        self.satisfaction = satisfaction
    }
}
