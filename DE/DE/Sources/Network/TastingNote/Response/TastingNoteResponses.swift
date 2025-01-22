// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct TastingNoteResponsesDTO : Decodable {
    public let noteId : Int
    public let wineId : Int
    public let wineName : String
    public let sort : String
    public let area : String
    public let imageUrl : String
    public let color : String
    public let tasteDate : String
    public let sugarContent : Int
    public let acidity : Int
    public let tannin : Int
    public let body : Int
    public let alcohol : Int
    public let noseMapList : [[String: String]]
    public let rating : Double
    public let review : String
}

public struct AllTastingNoteResponseDTO : Decodable {
    public let sortCount : TastingNoteSortCountResponse
    public let notePriviewList : [TastingNotePreviewResponseDTO]
}

public struct TastingNoteSortCountResponse : Decodable {
    public let totalCount : Int
    public let redCount : Int
    public let whiteCount : Int
    public let sparklingCount : Int
    public let roseCount : Int
    public let etcCount : Int
}

public struct TastingNotePreviewResponseDTO : Decodable {
    public let noteId : Int
    public let wineName : String
    public let imageUrl : String
    public let sort: String
}
