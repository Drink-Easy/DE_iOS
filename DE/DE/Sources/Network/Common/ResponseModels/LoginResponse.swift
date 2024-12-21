//
//  LoginResponse.swift
//  Drink-EG
//
//  Created by 김도연 on 8/18/24.
//

import Foundation

struct LoginResponse : Codable {
    let isFirst : Bool
    let role : String
    let username : String
}
