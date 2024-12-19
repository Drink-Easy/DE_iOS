//
//  APIResponsePostLikeResponse.swift
//  Drink-EG
//
//  Created by 이현주 on 8/21/24.
//

import Foundation

struct APIResponsePostLikeResponse : Codable {
    let isSuccess : Bool
    let code : String
    let message : String
    let result : WineList
}
