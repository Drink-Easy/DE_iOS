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
    public let total : Int
    public let red : Int
    public let white : Int
    public let sparkling : Int
    public let rose : Int
    public let etc : Int
    public let notePriviewList : [TastingNotePreviewResponseDTO]
}

public struct TastingNotePreviewResponseDTO : Decodable {
    public let noteId : Int
    public let wineName : String
    public let imageUrl : String
}
