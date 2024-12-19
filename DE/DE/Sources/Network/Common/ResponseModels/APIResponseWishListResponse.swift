//
//  APIResponseWishListResponse.swift
//  Drink-EG
//
//  Created by 이현주 on 8/20/24.
//

import Foundation

struct APIResponseWishListResponse : Codable {
    let isSuccess : Bool
    let code : String
    let message : String
    let result : [WineList]
}
