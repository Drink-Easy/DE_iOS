// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

enum AuthorizationEndpoints {
    case postLogin(data : LoginDTO)
    case postLogout
    case postJoin(data : JoinDTO)
    case postAppleLogin(data : AppleLoginRequestDTO)
    case postKakaoLogin
    
    case postReIssueToken
    case patchMemberInfo(data : MemberRequestDTO)
}

extension AuthorizationEndpoints: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.API.baseURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .postLogin:
            return "/login"
        case .postLogout:
            return "/logout"
        case .postJoin:
            return "/join"
        case .postAppleLogin:
            return "/login/apple"
            // TODO : 카카오 로그인 명세서 나오면 수정하기
        case .postKakaoLogin:
            return ""
        case .postReIssueToken:
            return "/reissue"
        case .patchMemberInfo:
            return "/member"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .patchMemberInfo :
            return .patch
        default:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .postLogin(let data):
            return .requestJSONEncodable(data)
        case .postLogout, .postReIssueToken:
            return .requestPlain
        case .postJoin(let data):
            return .requestJSONEncodable(data)
        case .postAppleLogin(let data):
            return .requestJSONEncodable(data)
        case .postKakaoLogin:
            // TODO : 아마도 dto -> return .requestJSONEncodable(data)
            return .requestPlain
        case .patchMemberInfo(let data):
            return .requestJSONEncodable(data)
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
