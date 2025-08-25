// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

public enum WishlistEndpoint {
    case getWishList
    case postWishList(wineId: Int, vintageYear: Int?)
    case deleteWineLike(wineId: Int, vintageYear: Int?)
}

extension WishlistEndpoint: TargetType {
    public var baseURL: URL {
        guard let url = URL(string: API.wishlistURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    public  var path: String {
        switch self {
        case let .postWishList(wineId, _):
            return "/\(wineId)"
        case let .deleteWineLike(wineId, _):
            return "/\(wineId)"
        default:
            return ""
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getWishList:
            return .get
        case .postWishList:
            return .post
        case .deleteWineLike:
            return .delete
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getWishList:
            return .requestPlain
            
        case let .postWishList(_, vintageYear):
            var parameters: [String: Any] = [:]
            if let vintageYear = vintageYear {
                parameters["vintageYear"] = vintageYear
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
        case let .deleteWineLike(_, vintageYear):
            var parameters: [String: Any] = [:]
            if let vintageYear = vintageYear {
                parameters["vintageYear"] = vintageYear
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
    
}
