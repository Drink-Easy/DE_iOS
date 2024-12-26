// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct LoginResponseDTO : Decodable {
    public let username : String
    public let role : String
    public let isFirst : Bool
}
