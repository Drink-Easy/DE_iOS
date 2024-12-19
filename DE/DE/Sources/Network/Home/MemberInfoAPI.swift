// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

enum MemberInfoAPI {
    case patchMember(data: MemberInfoRequest)
}

extension MemberInfoAPI: TargetType {
    var baseURL: URL {
        return URL(string: Constants.API.baseURL)!
    }
    
    var path: String {
        switch self {
        case .patchMember:
            return "/member"
        }
    }
    
    var method: Moya.Method {
        return .patch
    }
    
    var task: Moya.Task {
        switch self {
        case .patchMember(let data):
            return .requestJSONEncodable(data)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

