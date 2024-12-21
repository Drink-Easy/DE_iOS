// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

enum RecommentEndpoints {
    case postRecomments(requestDTO : RecommentRequestDTO)
    case deleteRecomments(recommentId : Int)
}

extension RecommentEndpoints : TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.API.recommentURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    var path: String {
        return "/"
    }
    
    var method: Moya.Method {
        switch self {
        case .postRecomments:
            return .post
        case .deleteRecomments:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postRecomments(let requestDTO):
            return .requestCompositeParameters(bodyParameters: ["Content": requestDTO.content], bodyEncoding: JSONEncoding.default, urlParameters: ["commentId": requestDTO.commentId])
        case .deleteRecomments(let id):
            return .requestParameters(parameters: ["recommentId": id], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
    
}
