// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya
import CoreModule

public enum WishlistEndpoint {
    case getWishList
    case postWishList(data: WineWishlistRequestDTO)
    case deleteWineLike(wineWishlistId: Int)
}

extension WishlistEndpoint: TargetType {
    public var baseURL: URL {
        guard let url = URL(string: Constants.API.wishlistURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    public  var path: String {
        switch self {
        case .deleteWineLike(let wineWishlistId):
            return "/\(wineWishlistId)"
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
        case .postWishList(let data):
            return .requestJSONEncodable(data)
        case .deleteWineLike(let wineWishlistId):
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
    
}
