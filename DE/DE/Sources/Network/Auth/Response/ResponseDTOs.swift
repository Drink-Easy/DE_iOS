// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

struct LoginResponseDTO : Decodable {
    let username : String
    let role : String
    let isFirst : Bool
}
