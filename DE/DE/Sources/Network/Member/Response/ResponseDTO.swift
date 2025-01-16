// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct MemberInfoResponse : Decodable {
    public let imageUrl : String?
    public let username : String?
    public let email : String?
    public let city : String?
    public let authType : String?
    public let adult : Bool?
    
    public init(imageUrl: String, username: String, email: String, city: String, authType: String, adult: Bool) {
        self.imageUrl = imageUrl
        self.username = username
        self.email = email
        self.city = city
        self.authType = authType
        self.adult = adult
    }
}
