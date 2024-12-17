//
//  BasicAPI.swift
//  Drink-EG
//
//  Created by 김도연 on 8/11/24.
//

import Foundation
import Moya

// JWT 토큰을 받을 수 있도록 BasicAPI 정의
/// 기능 하나 당 API 1개씩 만들기
/// - API 명세서 기준으로 1 명세서 당 1 API enum 정의하기
/// - 변경을 한 번 더 해보자.

enum BasicAPI {
    case getUser(id: Int)
    case createUser(name: String, email: String)
    case updateUser(id: Int, name: String, email: String)
    case deleteUser(id: Int)
}

extension BasicAPI: TargetType {
    var baseURL: URL {
        /// 기본 URL 작성
        return URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    var path: String {
        /// 기본 URL + path 로 URL 구성
        switch self {
            /// 동일한 path는 한 case로 처리 가능
        case .getUser(let id), .updateUser(let id, _, _), .deleteUser(let id):
            return "/users/\(id)"
        case .createUser:
            return "/users"
        }
    }
    
    var method: Moya.Method {
        /// 각 case 별로 적합한 method 배정
        switch self {
        case .getUser:
            return .get
        case .createUser:
            return .post
        case .updateUser:
            return .put
        case .deleteUser:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .getUser, .deleteUser:
            return .requestPlain
        case .createUser(let name, let email), .updateUser(_, let name, let email):
            return .requestParameters(parameters: ["name": name, "email": email], encoding: JSONEncoding.default)
        }
    }
    
    // API 호출 시, header에 token 넣어서 전달
    var headers: [String : String]? {
        let jwtToken = "jwt_token_here"
        return [
            "Authorization": "Bearer \(jwtToken)",
            "Content-type": "application/json"
        ]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}

