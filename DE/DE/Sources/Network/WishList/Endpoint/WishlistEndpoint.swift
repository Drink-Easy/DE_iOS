// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya
import CoreModule

enum WishlistEndpoint {
    case getWishList
    case postWishList(data: WineWishlistRequestDTO)
    case deleteWineLike(wineWishlistId: Int)
}

extension WishlistEndpoint: TargetType {
    var baseURL: URL {
        guard let url = URL(string: Constants.API.wishlistURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    var path: String {
        switch self {
        case .deleteWineLike(let wineWishlistId):
            return "/\(wineWishlistId)"
        default:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getWishList:
            return .get
        case .postWishList:
            return .post
        case .deleteWineLike:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getWishList:
            return .requestPlain
        case .postWishList(let data):
            return .requestJSONEncodable(data)
        case .deleteWineLike(wineWishlistId: let wineWishlistId):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
    
}
