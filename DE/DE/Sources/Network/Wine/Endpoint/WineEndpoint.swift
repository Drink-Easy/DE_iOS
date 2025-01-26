// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

public enum WineEndpoint {
    case getWines(searchName: String, page: Int)
    case getWineInfo(wineId: Int)
    case getWineReview(wineId: Int, sortType: String, page: Int)
    case getRecommendWines
    case getMostLikedWines
}

extension WineEndpoint: TargetType {
    public var baseURL: URL {
        guard let url = URL(string: API.wineURL) else {
            fatalError("잘못된 URL")
        }
        return url
    }
    
    public var path: String {
        switch self {
            case .getWines:
                return ""
        case .getWineInfo(let wineId):
            return "/\(wineId)"
        case .getWineReview(let wineId, _, _):
            return "/review/\(wineId)"
        case .getRecommendWines:
            return "/recommend"
        case .getMostLikedWines:
            return "/most-liked"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Moya.Task {
        switch self {
        case .getWines(let searchName, let page) :
            return .requestParameters(parameters: ["searchName": searchName, "page" : page, "size": 10], encoding: URLEncoding.queryString)
        case .getWineInfo, .getRecommendWines, .getMostLikedWines:
            return .requestPlain
        case .getWineReview(_, let sortType, let page):
            return .requestParameters(parameters: ["sortType": sortType, "page" : page, "size": 10], encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
    
    
}
