// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

public enum WineEndpoint {
    case getWines(searchName: String, page: Int)
    case getWineInfo(wineId: Int, vintageYear: Int?)
    case getWineReview(wineId: Int, vintageYear: Int?, sortType: String, page: Int)
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
        case let .getWineInfo(wineId, _):
            return "/\(wineId)"
        case let .getWineReview(wineId, _, _, _):
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
            return .requestParameters(
                parameters: [
                    "searchName": searchName,
                    "page" : page,
                    "size": 10
                ],
                encoding: URLEncoding.queryString
            )
            
        case let .getWineInfo(_, vintageYear):
            var parameters: [String: Any] = [:]
            if let vintageYear = vintageYear {
                parameters["vintageYear"] = vintageYear
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            
        case .getRecommendWines, .getMostLikedWines:
            return .requestPlain
            
        case let .getWineReview(_, vintageYear, sortType, page):
            var parameters: [String: Any] = [:]
            parameters["sortType"] = sortType
            parameters["page"] = page
            parameters["size"] = 10
            
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
