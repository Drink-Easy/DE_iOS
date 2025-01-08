// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import SwiftData

@Model
public class Wishlist {
    @Relationship var wishlishWines: [WineData] = []
    @Relationship var user: UserData?
    
    init(wishlishWines: [WineData], user: UserData? = nil) {
        self.wishlishWines = wishlishWines
        self.user = user
    }
}
