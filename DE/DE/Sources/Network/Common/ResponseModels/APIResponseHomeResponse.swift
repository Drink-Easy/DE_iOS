//
//  APIResponseHomeResponse.swift
//  Drink-EG
//
//  Created by 김도연 on 8/17/24.
//

import Foundation

struct APIResponseHomeResponse : Codable {
    let isSuccess : Bool
    let code : String
    let message : String
    let result : HomeResponse
}

struct HomeResponse : Codable {
    let name : String
    let recommendWineDTOs : [RecommendWineResponse]
}
