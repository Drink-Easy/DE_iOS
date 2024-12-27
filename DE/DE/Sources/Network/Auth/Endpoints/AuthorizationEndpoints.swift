// Copyright © 2024 DRINKIG. All rights reserved

import CoreModule
import Foundation
import Moya

public enum AuthorizationEndpoints {
    case postLogin(data : LoginDTO)
    case postLogout
    case postJoin(data : JoinDTO)
    case postAppleLogin(data : AppleLoginRequestDTO)
    case postKakaoLogin(data : KakaoLoginRequestDTO)
    
    case postReIssueToken
    case patchMemberInfo(data : MemberRequestDTO)
}

extension AuthorizationEndpoints: TargetType {
    public var baseURL: URL {
        guard let url = URL(string: Constants.API.baseURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    public var path: String {
        switch self {
        case .postLogin:
            return "/login"
        case .postLogout:
            return "/logout"
        case .postJoin:
            return "/join"
        case .postAppleLogin:
            return "/login/apple"
        case .postKakaoLogin:
            return "/login/kakao"
        case .postReIssueToken:
            return "/reissue"
        case .patchMemberInfo:
            return "/member"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .patchMemberInfo :
            return .patch
        default:
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case .postLogin(let data):
            return .requestJSONEncodable(data)
        case .postLogout, .postReIssueToken:
            return .requestPlain
        case .postJoin(let data):
            return .requestJSONEncodable(data)
        case .postAppleLogin(let data) :
            return .requestJSONEncodable(data)
        case .postKakaoLogin(let data) :
            return .requestJSONEncodable(data)
        case .patchMemberInfo(let data):
            return .requestJSONEncodable(data)
        }
    }
    
    public var headers: [String : String]? {
        var headers: [String: String] = [
            "Content-type": "application/json"
        ]
        
        switch self {
        case .patchMemberInfo, .postReIssueToken:
            if let cookies = HTTPCookieStorage.shared.cookies {
                let cookieHeader = HTTPCookie.requestHeaderFields(with: cookies)
                for (key, value) in cookieHeader {
                    headers[key] = value // 쿠키를 헤더에 추가
                }
            }
        default:
            break
        }
        return headers
    }

}
