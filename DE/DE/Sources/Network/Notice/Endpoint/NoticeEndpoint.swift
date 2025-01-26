// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

public enum NoticeEndpoint {
    case getAllNotices
    case getNotice(id : Int)
    
    case getBanner
}

extension NoticeEndpoint: TargetType {
    public var baseURL: URL {
        switch self {
        case .getBanner:
            guard let url = URL(string: API.baseURL) else {
                fatalError("잘못된 URL")
            }
            return url
        default :
            guard let url = URL(string: API.noticeURL) else {
                fatalError("잘못된 URL")
            }
            return url
        }
    }
    
    public var path: String {
        switch self {
        case .getAllNotices:
            return ""
        case .getNotice(let id):
            return "/\(id)"
        case .getBanner:
            return "/banner"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Moya.Task {
        switch self {
        case .getAllNotices:
            return .requestPlain
        case .getNotice:
            return .requestPlain
        case .getBanner:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
}
