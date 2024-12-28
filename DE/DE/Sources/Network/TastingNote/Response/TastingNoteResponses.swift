// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct TastingNoteResponsesDTO : Decodable {
    let noteId : Int
    let wineId : Int
    let wineName : String
    let sort : String
    let area : String
    let imageUrl : String
    let color : String
    let tasteDate : String
    let sugarContent : Int
    let acidity : Int
    let tannin : Int
    let body : Int
    let alcohol : Int
    let noseMapList : [Int: String]
    let satisfaction : Double
    let review : String
}

public struct AllTastingNoteResponseDTO : Decodable {
    let total : Int
    let red : Int
    let white : Int
    let sparkling : Int
    let rose : Int
    let etc : Int
    let notePriviewList : [TastingNotePreviewResponseDTO]?
}

public struct TastingNotePreviewResponseDTO : Decodable {
    let noteId : Int?
    let wineName : String?
    let imageUrl : String?
}
