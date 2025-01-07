// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import SwiftData

@Model
public class UserData {
    @Attribute(.unique) public var userId : Int
    public var userName: String?
    @Relationship public var wines : [WineList] = []
        var wishlist: Wishlist
}
