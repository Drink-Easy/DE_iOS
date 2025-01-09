// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct LoginResponseDTO : Decodable {
    public let username : String?
    public let role : String?
    public let isFirst : Bool
    public let id: Int
}

public struct MemberResponseDTO : Codable {
    let id : Int
    let name : String
    let username : String
    let role: String
    let isNewBie : Bool?
    let isFirst : Bool
    let monthPriceMax : Int
    let wineSort : [String]
    let wineArea : [String]
    let region : String
}

public struct UsernameCheckResponse: Decodable {
    public let isDuplicate : Bool
}
