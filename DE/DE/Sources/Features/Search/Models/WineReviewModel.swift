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
    let avgSugarContent: Double
    let avgAcidity: Double
    let avgTannin: Double
    let avgBody: Double
    let avgAlcohol: Double
    
    init(wineNoseText: String, avgSugarContent: Double, avgAcidity: Double, avgTannin: Double, avgBody: Double, avgAlcohol: Double) {
        self.wineNoseText = wineNoseText
        self.avgSugarContent = avgSugarContent
        self.avgAcidity = avgAcidity
        self.avgTannin = avgTannin
        self.avgBody = avgBody
        self.avgAlcohol = avgAlcohol
    }
}

extension WineAverageTastingNoteModel {
    func sugarContentDescription() -> String {
        switch avgSugarContent {
        case 0...20.0: return "당도 없음"
        case 20.0...40.0: return "드라이"
        case 40.0...60.0: return "오프 드라이"
        case 60.0...80.0: return "미디엄 스위트"
        case 80.0...100.0: return "스위트"
        default: return "sugar"
        }
    }

    func acidityDescription() -> String {
        switch avgAcidity {
        case 0...20.0: return "산미 없음"
        case 20.0...40.0: return "미세한 산미"
        case 40.0...60.0: return "약한 산미"
        case 60.0...80.0: return "보통 산미"
        case 80.0...100.0: return "거친 산미"
        default: return "acidity"
        }
    }

    func tanninDescription() -> String {
        switch avgTannin {
        case 0...20.0: return "타닌 없음"
        case 20.0...40.0: return "미세한 타닌"
        case 40.0...60.0: return "약한 타닌"
        case 60.0...80.0: return "보통 타닌"
        case 80.0...100.0: return "높은 타닌"
        default: return "tannin"
        }
    }

    func bodyDescription() -> String {
        switch avgBody {
        case 0...20.0: return "바디감 없음"
        case 20.0...40.0: return "라이트 바디"
        case 40.0...60.0: return "미디엄 바디"
        case 60.0...80.0: return "미디엄-풀 바디"
        case 80.0...100.0: return "풀 바디"
        default: return "body"
        }
    }

    func alcoholDescription() -> String {
        switch avgAlcohol {
        case 0...20.0: return "알코올 없음"
        case 20.0...40.0: return "미세한 알코올"
        case 40.0...60.0: return "약한 알코올"
        case 60.0...80.0: return "보통 알코올"
        case 80.0...100.0: return "높은 알코올"
        default: return "alcohol"
        }
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
