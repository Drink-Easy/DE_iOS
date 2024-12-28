// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct WineWishlistResponseDTO : Decodable {
    public  let id : Int
    public let wine : SearchWineResponseDTO
}
