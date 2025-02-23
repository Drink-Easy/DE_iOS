// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct MemberUpdateRequest: Codable {
    public let name : String?
    
    public init(username: String?) {
        self.name = username
    }
}

public struct MemberRequestDTO : Codable {
    public let name : String
    public let isNewbie : Bool
    public let monthPrice : Int
    public let wineSort : [String]
    public let wineArea : [String]
    public let wineVariety : [String]
    
    public init(name: String, isNewbie: Bool, monthPrice: Int, wineSort: [String], wineArea: [String], wineVariety: [String]) {
        self.name = name
        self.isNewbie = isNewbie
        self.monthPrice = monthPrice
        self.wineSort = wineSort
        self.wineArea = wineArea
        self.wineVariety = wineVariety
    }
}

public struct AppleDeleteRequest : Codable {
    public let authorizationCode : String
    
    public init(authorizationCode: String) {
        self.authorizationCode = authorizationCode
    }
}
