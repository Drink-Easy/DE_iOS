// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

public struct WineReviewModel {
    public let name: String
    public let contents: String
    public let rating: Double
    public let createdAt: String
    
    public init(name: String, contents: String, rating: Double, createdAt: String) {
        self.name = name
        self.contents = contents
        self.rating = rating
        self.createdAt = createdAt
    }
}

public struct WineDetailTopModel {
    public let isLiked : Bool
    public let wineName : String
    
    public init(isLiked: Bool, wineName: String) {
        self.isLiked = isLiked
        self.wineName = wineName
    }
}

public struct WineDetailInfoModel {
    public let image: String
    public let sort: String
    public let country: String
    public let region: String
    public let variety: String
    
    public init(image: String, sort: String, country: String, region: String, variety: String) {
        self.image = image
        self.sort = sort
        self.country = country
        self.region = region
        self.variety = variety
    }
}

public struct WineViVinoRatingModel {
    public let vivinoRating: Double
    
    public init(vivinoRating: Double) {
        self.vivinoRating = vivinoRating
    }
}

public struct WineAverageTastingNoteModel {
    public let wineNoseText: String
    public let avgSugarContent: Double
    public let avgAcidity: Double
    public let avgTannin: Double
    public let avgBody: Double
    public let avgAlcohol: Double
    
    public init(wineNoseText: String, avgSugarContent: Double, avgAcidity: Double, avgTannin: Double, avgBody: Double, avgAlcohol: Double) {
        self.wineNoseText = wineNoseText
        self.avgSugarContent = avgSugarContent
        self.avgAcidity = avgAcidity
        self.avgTannin = avgTannin
        self.avgBody = avgBody
        self.avgAlcohol = avgAlcohol
    }
}

extension WineAverageTastingNoteModel {
    public func sugarContentDescription() -> String {
        switch avgSugarContent {
        case 0...20.0: return "당도 없음"
        case 20.0...40.0: return "드라이"
        case 40.0...60.0: return "오프 드라이"
        case 60.0...80.0: return "미디엄 스위트"
        case 80.0...100.0: return "스위트"
        default: return "sugar"
        }
    }

    public func acidityDescription() -> String {
        switch avgAcidity {
        case 0...20.0: return "산미 없음"
        case 20.0...40.0: return "미세한 산미"
        case 40.0...60.0: return "약한 산미"
        case 60.0...80.0: return "보통 산미"
        case 80.0...100.0: return "거친 산미"
        default: return "acidity"
        }
    }

    public func tanninDescription() -> String {
        switch avgTannin {
        case 0...20.0: return "타닌 없음"
        case 20.0...40.0: return "미세한 타닌"
        case 40.0...60.0: return "약한 타닌"
        case 60.0...80.0: return "보통 타닌"
        case 80.0...100.0: return "높은 타닌"
        default: return "tannin"
        }
    }

    public func bodyDescription() -> String {
        switch avgBody {
        case 0...20.0: return "바디감 없음"
        case 20.0...40.0: return "라이트 바디"
        case 40.0...60.0: return "미디엄 바디"
        case 60.0...80.0: return "미디엄-풀 바디"
        case 80.0...100.0: return "풀 바디"
        default: return "body"
        }
    }

    public func alcoholDescription() -> String {
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

public struct WineAverageReviewModel {
    public let avgMemberRating: Double
    
    public init(avgMemberRating: Double) {
        self.avgMemberRating = avgMemberRating
    }
}

public struct WineDetailData {
    public let top : WineDetailTopModel
    public let info : WineDetailInfoModel
    public let rate : WineViVinoRatingModel
    public let avg : WineAverageTastingNoteModel
    public let review : WineAverageReviewModel
    
    public init(top: WineDetailTopModel, info: WineDetailInfoModel, rate: WineViVinoRatingModel, avg: WineAverageTastingNoteModel, review: WineAverageReviewModel) {
        self.top = top
        self.info = info
        self.rate = rate
        self.avg = avg
        self.review = review
    }
}
