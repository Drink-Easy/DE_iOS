// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

enum RecommentEndpoints {
    case postRecomments(id : Int)
    case deleteRecomments(id : Int)
}

extension RecommentEndpoints : TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.API.baseURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    var path: String {
        <#code#>
    }
    
    var method: Moya.Method {
        <#code#>
    }
    
    var task: Moya.Task {
        <#code#>
    }
    
    var headers: [String : String]? {
        <#code#>
    }
    
    
}

