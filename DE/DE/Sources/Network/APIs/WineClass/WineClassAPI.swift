//
//  WineClassAPI.swift
//  Drink-EG
//
//  Created by 김도연 on 8/12/24.
//

import Foundation
import Moya

enum WineClassAPI {
    case getAllWineClass
    case getWineClass(id: Int)
}

extension WineClassAPI: TargetType {
    var baseURL: URL {
        return URL(string: Constants.API.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getAllWineClass:
            return "/wine-class"
        case .getWineClass(let id):
            return "/wine-class/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAllWineClass, .getWineClass:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getAllWineClass:
            return .requestPlain
        case .getWineClass(let id):
            return .requestParameters(parameters: ["wineClassId" : id], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return [
            "Content-type": "application/json"
        ]
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
}
