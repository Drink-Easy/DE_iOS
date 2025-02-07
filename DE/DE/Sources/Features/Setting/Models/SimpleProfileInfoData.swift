// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct SimpleProfileInfoData {
    public let name: String
    public let imageURL: String?
    
    public init(name: String, imageURL: String? = nil) {
        self.name = name
        self.imageURL = imageURL
    }
}
