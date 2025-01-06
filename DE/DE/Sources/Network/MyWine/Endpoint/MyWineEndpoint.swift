// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import CoreModule
import Moya

public enum MyWineEndpoint {
    case getMyWines
    case postMyWine(data: MyWineRequest)
    case patchMyWine(wineId: Int, data : MyWineUpdateRequest)
}

extension MyWineEndpoint: TargetType {
    public var baseURL: URL {
        guard let url = URL(string: Constants.API.myWineURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    public var path: String {
        switch self {
        case .patchMyWine(let id, _):
            return "/\(id)"
        default :
            return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getMyWines:
            return .get
        case .postMyWine:
            return .post
        case .patchMyWine:
            return .patch
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getMyWines:
            return .requestPlain
        case .postMyWine(let data):
            return .requestJSONEncodable(data)
        case .patchMyWine(_, let data):
            return .requestJSONEncodable(data)
        }
    }
    
    public var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
    
    
}
