//
//  RecommendWineResponse.swift
//  Drink-EG
//
//  Created by 김도연 on 8/17/24.
//

import Foundation

struct RecommendWineResponse : Codable{
    let wineId : Int
    let wineName : String
    let imageUrl : String
}
