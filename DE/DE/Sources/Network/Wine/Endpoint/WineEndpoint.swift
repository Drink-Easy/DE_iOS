// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya
import CoreModule

public enum WineEndpoint {
    case getWines(searchName: String)
    case getWineInfo(wineId: Int)
    case getWineReview(wineId: Int)
}

extension WineEndpoint: TargetType {
    public var baseURL: URL {
        guard let url = URL(string: Constants.API.wineURL) else {
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
        case .getWineReview(let wineId):
            return "/review/\(wineId)"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Moya.Task {
        switch self {
        case .getWines(let searchName):
            return .requestParameters(parameters: ["searchName": searchName], encoding: URLEncoding.queryString)
        case .getWineInfo(let wineId):
            return .requestPlain
        case .getWineReview(let wineId):
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
    
    
}
