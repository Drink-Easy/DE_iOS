// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct SimpleProfileInfoData {
    public let name: String
    public let imageURL: String
    public let uniqueUserId: Int
    
    public init(name: String, imageURL: String, uniqueUserId: Int) {
        self.name = name
        self.imageURL = imageURL
        self.uniqueUserId = uniqueUserId
    }
}
