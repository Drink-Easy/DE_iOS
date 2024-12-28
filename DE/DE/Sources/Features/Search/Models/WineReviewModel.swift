// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

struct WineReviewModel {
    let name: String
    let contents: String
    let rating: Double
    
    init(name: String, contents: String, rating: Double) {
        self.name = name
        self.contents = contents
        self.rating = rating
    }
}
