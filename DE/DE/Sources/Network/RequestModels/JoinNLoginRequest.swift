//
//  JoinLoginRequest.swift
//  Drink-EG
//
//  Created by 이현주 on 8/12/24.
//

import Foundation

struct JoinNLoginRequest : Codable {
    let username : String
    let password : String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
