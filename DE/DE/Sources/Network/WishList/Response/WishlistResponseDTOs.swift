// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

struct WineWishlistResponseDTO : Decodable {
    let id : Int
    let wine : SearchWineResponseDTO
}
