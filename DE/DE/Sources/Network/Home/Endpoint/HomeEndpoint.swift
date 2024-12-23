// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

enum HomeEndpoint {
    case getHomeInfo
}

extension HomeEndpoint: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.API.baseURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    var path: String {
        return "/home"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
    
    
}
