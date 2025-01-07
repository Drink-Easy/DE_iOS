// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct MemberInfoResponse : Decodable {
    public let imageUrl : String
    public let username : String
    public let email : String
    public let city : String
    public let authType : String
    public let adult : Bool
}

