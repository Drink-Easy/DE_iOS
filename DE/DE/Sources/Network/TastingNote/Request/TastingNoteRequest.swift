// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

/*
 {
   "wineId": 0,
   "color": "string",
   "tasteDate": "2024-12-28",
   "sugarContent": 10,
   "acidity": 10,
   "tannin": 10,
   "body": 10,
   "alcohol": 10,
   "nose": [
     "string"
   ],
   "rating": 5,
   "review": "string"
 }*/

public struct TastingNoteRequestDTO : Codable {
    let wineId : Int
    let color : String
    let tasteDate : String
    let sugarContent: Int
    let acidity : Int
    let tannin : Int
    let body : Int
    let alcohol : Int
    let nose : [String]
    let rating : Double
    let review : String
    
    public init(wineId: Int, color: String, tasteDate: String, sugarContent: Int, acidity: Int, tannin: Int, body: Int, alcohol: Int, nose: [String], rating: Double, review: String) {
        self.wineId = wineId
        self.color = color
        self.tasteDate = tasteDate
        self.sugarContent = sugarContent
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
    let sugarContent: Int?
    let acidity : Int?
    let tannin : Int?
    let body : Int?
    let alcohol : Int?
    let addNoseList : [String]?
    let removeNoseList : [Int]?
    let rating : Double?
    let review : String?
    
    public init(color: String?, tastingDate: String?, sugarContent: Int?, acidity: Int?, tannin: Int?, body: Int?, alcohol: Int?, addNoseList: [String]?, removeNoseList: [Int]?, rating: Double?, review: String?) {
        self.color = color
        self.tastingDate = tastingDate
        self.sugarContent = sugarContent
        self.acidity = acidity
        self.tannin = tannin
        self.body = body
        self.alcohol = alcohol
        self.addNoseList = addNoseList
        self.removeNoseList = removeNoseList
        self.rating = rating
        self.review = review
    }
}
