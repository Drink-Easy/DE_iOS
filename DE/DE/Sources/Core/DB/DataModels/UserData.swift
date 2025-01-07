// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import SwiftData

@Model
public class UserData {
    @Attribute(.unique) var userId : Int
    var userName: String
    var wines : [WineList] = []
    
    init(userId: Int, userName: String, wines: [WineList] = [] ) {
        self.userId = userId
        self.userName = userName
        self.wines = wines
    }
}
