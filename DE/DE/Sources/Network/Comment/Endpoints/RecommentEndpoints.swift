// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

enum RecommentEndpoints {
    case postRecomments(id : Int)
    case deleteRecomments(id : Int)
}

extension RecommentEndpoints : TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.API.recommentURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    var path: String {
        return "/"
    }
    
    var method: Moya.Method {
        switch self {
        case .postRecomments:
            return .post
        case .deleteRecomments:
            return .delete
        }
    }
    
    var task: Moya.Task {
        <#code#>
    }
    
    var headers: [String : String]? {
        <#code#>
    }
}

