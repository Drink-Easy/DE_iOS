// Copyright © 2024 DRINKIG. All rights reserved

import CoreModule
import Foundation
import Moya

public enum MemberEndpoint {
    // 마이페이지
    case getMemberInfo
    case patchMemeberPersonalInfo
    case checkNickname(nickname: String)
    case deleteMember
    
    // 취향찾기
    case patchMemberInfo(data : MemberRequestDTO)
}

extension MemberEndpoint: TargetType {
    public var baseURL: URL {
        guard let url = URL(string: Constants.API.memberURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    public var path: String {
        switch self {
        case .patchMemberInfo :
            return ""
        case .checkNickname(let name) :
            return "/\(name)"
        case .deleteMember :
            return "/delete"
        default :
            return "/info"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .checkNickname :
            return .post
        case .getMemberInfo :
            return .get
        case .patchMemberInfo, .patchMemeberPersonalInfo :
            return .patch
        case .deleteMember :
            return .delete
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getMemberInfo:
                .requestPlain
        case .patchMemeberPersonalInfo:
                .requestPlain
        case .checkNickname(let nickname):
                .requestParameters(parameters: ["nickname": nickname], encoding: URLEncoding.queryString)
        case .deleteMember:
                .requestPlain
        case .patchMemberInfo(data: let data):
                .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return [ "Content-type": "application/json" ]
    }

}
