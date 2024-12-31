// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

struct NoteResponse : Codable {
    let noteId : Int
    let wineId : Int
    let wineName : String
    let sort: String
    let area: String
    let imageUrl : String
    let color : String
    let sugarContent : Int
    let acidity : Int
    let tannin : Int
    let body : Int
    let alcohol : Int
    let scentAroma : [String]
    let scentTaste : [String]
    let scentFinish : [String]
    let satisfaction : Double
    let review : String?
}

struct ResponseWrap: Codable {
    let result: NoteResponse
}
