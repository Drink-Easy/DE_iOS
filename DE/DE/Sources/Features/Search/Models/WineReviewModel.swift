// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

struct WineReviewModel {
    let name: String
    let contents: String
    let rating: Double
    let createdAt: String
    
    init(name: String, contents: String, rating: Double, createdAt: String) {
        self.name = name
        self.contents = contents
        self.rating = rating
        self.createdAt = createdAt
    }
}

struct WineDetailTopModel {
    let isLiked : Bool
    let wineName : String
    
    init(isLiked: Bool, wineName: String) {
        self.isLiked = isLiked
        self.wineName = wineName
    }
}

struct WineDetailInfoModel {
    let image: String
    let sort: String
    let area: String
    let variety: String
    
    init(image: String, sort: String, area: String, variety: String = "") {
        self.image = image
        self.sort = sort
        self.area = area
        self.variety = variety
    }
}

struct WineViVinoRatingModel {
    let vivinoRating: Double
    
    init(vivinoRating: Double) {
        self.vivinoRating = vivinoRating
    }
}

struct WineAverageTastingNoteModel {
    let wineNoseText: String
    let 
    
    init(wineNoseText: String = "") {
        self.wineNoseText = wineNoseText
    }
}

struct WineAverageReviewModel {
    let avgMemberRating: Double
}

struct WineData {
    let top : WineDetailTopModel
    let info : WineDetailInfoModel
    let rate : WineViVinoRatingModel
    let avg : WineAverageTastingNoteModel
    let review : WineAverageReviewModel
    
    init(top: WineDetailTopModel, info: WineDetailInfoModel, rate: WineViVinoRatingModel, avg: WineAverageTastingNoteModel, review: WineAverageReviewModel) {
        self.top = top
        self.info = info
        self.rate = rate
        self.avg = avg
        self.review = review
    }
}
