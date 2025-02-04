// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

public enum MyWineEndpoint {
    case getMyWines
    case getOneMyWine(myWineId: Int)
    case postMyWine(data: MyWineRequest)
    case patchMyWine(myWineId: Int, data : MyWineUpdateRequest)
    case deleteMyWine(myWineId: Int)
}

extension MyWineEndpoint: TargetType {
    public var baseURL: URL {
        guard let url = URL(string: API.myWineURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    public var path: String {
        switch self {
        case .patchMyWine(let id, _), .deleteMyWine(let id), .getOneMyWine(let id):
            return "/\(id)"
        default :
            return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getMyWines, .getOneMyWine:
            return .get
        case .postMyWine:
            return .post
        case .patchMyWine:
            return .patch
        case .deleteMyWine:
            return .delete
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .postMyWine(let data):
            return .requestJSONEncodable(data)
        case .patchMyWine(_, let data):
            return .requestJSONEncodable(data)
        default :
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
    
    
}
