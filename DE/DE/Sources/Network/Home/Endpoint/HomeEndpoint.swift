// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya
import CoreModule

public enum HomeEndpoint {
    case getHomeInfo
}

extension HomeEndpoint: TargetType {
    public var baseURL: URL {
        guard let url = URL(string: Constants.API.baseURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    public var path: String {
        return "/home"
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Moya.Task {
        return .requestPlain
    }
    
    public var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
    
    
}
