// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

enum LoginAPI {
    case postLogin(data: JoinNLoginRequest)
    case postRegister(data : JoinNLoginRequest)
    case postAppleLogin(identityTokenString: String)
}

extension LoginAPI: TargetType {
    var baseURL: URL {
        /// 기본 URL 작성
        return URL(string: "https://drinkeg.com")!
    }
    
    var path: String {
        /// 기본 URL + path 로 URL 구성
        switch self {
            /// 동일한 path는 한 case로 처리 가능
        case .postLogin:
            return "/login"
        case .postRegister:
            return "/join"
        case .postAppleLogin:
            return"/login/apple"
        }
    }
    
    var method: Moya.Method {
        /// 각 case 별로 적합한 method 배정
        switch self {
        case .postLogin:
            return .post
        case .postRegister:
            return .post
        case .postAppleLogin:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .postLogin(let data), .postRegister(let data) :
            return .requestJSONEncodable(data)
        case .postAppleLogin(let identityTokenString) :
            return .requestParameters(parameters: ["identityToken" : identityTokenString], encoding: JSONEncoding.default)
        }
    }
    
    // API 호출 시, header에 token 넣어서 전달
    var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
