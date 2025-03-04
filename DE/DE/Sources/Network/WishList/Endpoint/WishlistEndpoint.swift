// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

public enum WishlistEndpoint {
    case getWishList
    case postWishList(wineId: Int)
    case deleteWineLike(wineId: Int)
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
        case .postWishList(let wineId):
            return "/\(wineId)"
        case .deleteWineLike(let wineId):
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
        case .postWishList(_):
            return .requestPlain
        case .deleteWineLike(_):
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
    
}
