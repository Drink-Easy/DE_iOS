// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

struct TastingNoteRequestDTO : Codable {
    let wineId : Int
    let color : String
    let tasteDate : String
    let sugarContent: Int
    let acidity : Int
    let tannin : Int
    let body : Int
    let alcohol : Int
    let nose : [String]
    let satisfaction : Double
    let review : String
}

struct TastingNotePatchRequestDTO : Codable {
    let noteId : Int
    let body : TastingNoteUpdateRequestDTO
}

struct TastingNoteUpdateRequestDTO : Codable {
    let color : String?
    let tastingDate : String?
    let sugarContent: Int?
    let acidity : Int?
    let tannin : Int?
    let body : Int?
    let alcohol : Int?
    let addNoseList : [String]?
    let removeNoseList : [Int]?
    let satisfaction : Double?
    let review : String?
}
