// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

public enum CommentEndpoints {
    case postComments(data : CommentRequestDTO)
    case deleteComments(commentId : Int)
    case patchComments(commentId : Int)
    case getComments(partyId : Int)
    case getCommentsCount(partyId : Int)
}

extension CommentEndpoints : TargetType {
    public var baseURL: URL {
        guard let url = URL(string: API.commentURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    public var path: String {
        switch self {
        case .deleteComments(let commentId), .patchComments(let commentId):
            return "/\(commentId)"
        case .getComments(let partyId):
            return "/\(partyId)"
        case .getCommentsCount(let partyId):
            return "/count/\(partyId)"
        default:
            return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .postComments:
            return .post
        case .deleteComments:
            return .delete
        case .patchComments:
            return .patch
        default:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .postComments(let data):
            return .requestJSONEncodable(data)
        case .deleteComments, .patchComments, .getComments, .getCommentsCount:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
    
}
