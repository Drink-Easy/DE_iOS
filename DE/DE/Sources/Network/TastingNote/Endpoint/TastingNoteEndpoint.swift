// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya
import CoreModule

enum TastingNoteEndpoint {
    case postNote(data : TastingNoteRequestDTO)
    case getNote(noteId : Int)
    case deleteNote(noteId : Int)
    case patchNote(data : TastingNotePatchRequestDTO)
    case getAllNotes(sort : String)
}

extension TastingNoteEndpoint: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.API.tastingNoteURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .postNote:
            return "/new-note"
        case .getNote, .deleteNote:
            return "/"
        case .patchNote(let data):
            return "/\(data.noteId)"
        case .getAllNotes:
            return "/all"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postNote:
            return .post
        case .deleteNote:
            return .delete
        case .patchNote:
            return .patch
        default :
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postNote(let data):
            return .requestJSONEncodable(data)
        case .getNote(let noteId):
            return .requestParameters(parameters: ["noteId" : noteId], encoding: URLEncoding.queryString)
        case .deleteNote(let noteId):
            return .requestParameters(parameters: ["noteId" : noteId], encoding: URLEncoding.queryString)
        case .patchNote(let data):
            return .requestJSONEncodable(data.body)
        case .getAllNotes(let sort):
            return .requestParameters(parameters: ["sort" : sort], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return [ "Content-type": "application/json" ]
    }
    
}