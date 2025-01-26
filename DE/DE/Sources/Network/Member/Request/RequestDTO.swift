// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct MemberUpdateRequest: Codable {
    public let name : String?
    public let region : String?
    
    public init(username: String?, city: String?) {
        self.name = username
        self.region = city
    }
}

public struct MemberRequestDTO : Codable {
    public let name : String
    public let isNewbie : Bool
    public let monthPrice : Int
    public let wineSort : [String]
    public let wineArea : [String]
    public let wineVariety : [String]
    public let region : String
    
    public init(name: String, isNewbie: Bool, monthPrice: Int, wineSort: [String], wineArea: [String], wineVariety: [String], region: String) {
        self.name = name
        self.isNewbie = isNewbie
        self.monthPrice = monthPrice
        self.wineSort = wineSort
        self.wineArea = wineArea
        self.wineVariety = wineVariety
        self.region = region
    }
}

public struct AppleDeleteRequest : Codable {
    public let authorizationCode : String
    
    public init(authorizationCode: String) {
        self.authorizationCode = authorizationCode
    }
}
