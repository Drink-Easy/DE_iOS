// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct TastingNoteResponsesDTO : Decodable {
    public let noteId : Int
    public let wineId : Int
    public let wineName : String
    public let sort : String
    public let country : String
    public let region : String
    public let variety : String
    public let imageUrl : String
    public let color : String
    public let tasteDate : String
    public let sweetness : Int
    public let acidity : Int
    public let tannin : Int
    public let body : Int
    public let alcohol : Int
    public let noseList : [String]
    public let rating : Double
    public let review : String
}

public struct AllTastingNoteResponseDTO : Decodable {
    public let sortCount : TastingNoteSortCountResponse
    public let pageResponse : PageResponseTastingNotePreviewResponse
}

public struct PageResponseTastingNotePreviewResponse : Decodable {
    public let content : [TastingNotePreviewResponseDTO]
    public let pageNumber : Int
    public let totalPages : Int
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
