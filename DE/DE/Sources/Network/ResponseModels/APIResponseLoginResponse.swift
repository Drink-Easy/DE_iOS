//
//  APIResponseLoginResponse.swift
//  Drink-EG
//
//  Created by 이현주 on 8/13/24.
//

import Foundation

struct APIResponseLoginResponse : Codable {
    let isSuccess: Bool
    let accessToken: String
    let refreshToken: String
}
