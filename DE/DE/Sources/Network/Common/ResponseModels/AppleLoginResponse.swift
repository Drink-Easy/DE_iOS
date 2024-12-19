//
//  AppleLoginResponse.swift
//  Drink-EG
//
//  Created by 김도연 on 8/20/24.
//

import Foundation

struct AppleLoginResponse : Codable {
    let isSuccess : Bool
    let code : String
    let message : String
    let result : LoginResponse
}
