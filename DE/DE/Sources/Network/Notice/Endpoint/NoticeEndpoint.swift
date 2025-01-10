// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

public enum NoticeEndpoint {
    case getAllNotices
    case getNotice(id : Int)
}

extension NoticeEndpoint: TargetType {
    public var baseURL: URL {
        guard let url = URL(string: API.noticeURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    public var path: String {
        switch self {
        case .getAllNotices:
            return ""
        case .getNotice(let id):
            return "/\(id)"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Moya.Task {
        switch self {
        case .getAllNotices:
            return .requestPlain
        case .getNotice(let id):
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
}
