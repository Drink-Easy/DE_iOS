// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import SwiftData

@Model
public class UserData {
    @Attribute(.unique) public var userId : Int
    public var userName: String
    public var wines : [WineList] = []
    
    init(userId: Int, userName: String, wines: [WineList] = [] ) {
        self.userId = userId
        self.userName = userName
        self.wines = wines
    }
}
