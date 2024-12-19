// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

struct JoinNLoginRequest : Codable {
    let username : String
    let password : String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
