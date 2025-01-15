// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

struct HomeWineModel {
    let wineId : Int
    let imageUrl: String
    let wineName: String
    let sort : String
    let price : Int
    let vivinoRating: Double
    
    init(wineId: Int, imageUrl: String, wineName: String, sort: String, price: Int, vivinoRating: Double) {
        self.wineId = wineId
        self.imageUrl = imageUrl
        self.wineName = wineName
        self.sort = sort
        self.price = price
        self.vivinoRating = vivinoRating
    }
}

