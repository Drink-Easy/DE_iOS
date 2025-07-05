// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct TastingNoteRequestDTO : Codable {
    let wineId : Int
    let vintageYear: Int?
    let color : String
    let tasteDate : String
    let sweetness: Int
    let acidity : Int
    let tannin : Int
    let body : Int
    let alcohol : Int
    let nose : [String]?
    let rating : Double
    let review : String?
    
    public init(
        wineId: Int,
        vintageYear: Int?,
        color: String,
        tasteDate: String,
        sweetness: Int,
        acidity: Int,
        tannin: Int,
        body: Int,
        alcohol: Int,
        nose: [String]?,
        rating: Double,
        review: String?
    ) {
        self.wineId = wineId
        self.vintageYear = vintageYear
        self.color = color
        self.tasteDate = tasteDate
        self.sweetness = sweetness
        self.acidity = acidity
        self.tannin = tannin
        self.body = body
        self.alcohol = alcohol
        self.nose = nose
        self.rating = rating
        self.review = review
    }
}

public struct TastingNotePatchRequestDTO : Codable {
    let noteId : Int
    let body : TastingNoteUpdateRequestDTO
    
    public init(noteId: Int, body: TastingNoteUpdateRequestDTO) {
        self.noteId = noteId
        self.body = body
    }
}

public struct TastingNoteUpdateRequestDTO : Codable {
    let color : String?
    let tastingDate : String?
    let sweetness: Int?
    let acidity : Int?
    let tannin : Int?
    let body : Int?
    let alcohol : Int?
    let updateNoseList : [String]?
    let rating : Double?
    let review : String?
    
    public init(color: String?, tastingDate: String?, sugarContent: Int?, acidity: Int?, tannin: Int?, body: Int?, alcohol: Int?, updateNoseList: [String]?, rating: Double?, review: String?) {
        self.color = color
        self.tastingDate = tastingDate
        self.sweetness = sugarContent
        self.acidity = acidity
        self.tannin = tannin
        self.body = body
        self.alcohol = alcohol
        self.updateNoseList = updateNoseList
        self.rating = rating
        self.review = review
    }
}
