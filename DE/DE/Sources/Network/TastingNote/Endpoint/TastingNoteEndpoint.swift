// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

public enum TastingNoteEndpoint {
    case postNote(data : TastingNoteRequestDTO)
    case getNote(noteId : Int)
    case deleteNote(noteId : Int)
    case patchNote(data : TastingNotePatchRequestDTO)
    case getAllNotes(sort : String, page: Int, size: Int = 10)
    case searchNote(searchName: String, page: Int, size: Int = 10)
}

extension TastingNoteEndpoint: TargetType {
    public var baseURL: URL {
        guard let url = URL(string: API.tastingNoteURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    public var path: String {
        switch self {
        case .postNote:
            return "/new-note"
        case .getNote(let id), .deleteNote(let id):
            return "/\(id)"
        case .patchNote(let data):
            return "/\(data.noteId)"
        case .getAllNotes:
            return "/all"
        default:
            return ""
        }
    }
    
    public var method: Moya.Method {
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
    
    public var task: Moya.Task {
        switch self {
        case .postNote(let data):
            return .requestJSONEncodable(data)
        case .getNote(_):
            return .requestPlain
        case .deleteNote(_):
            return .requestPlain
        case .patchNote(let data):
            return .requestJSONEncodable(data.body)
        case .getAllNotes(let sort, let page, let size):
            return .requestParameters(
                parameters: ["sort" : sort,
                             "page" : page,
                             "size" : size],
                encoding: URLEncoding.queryString)
        case .searchNote(let searchName, let page, let size):
            return .requestParameters(
                parameters: ["SearchName" : searchName,
                             "page" : page,
                             "size" : size],
                encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String : String]? {
        return [ "Content-type": "application/json" ]
    }
    
}
