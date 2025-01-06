// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct MyWineResponse : Decodable {
    public let myWineid : Int
    public let wineId : Int
    public let wineName : String
    public let wineSort : String
    public let wineArea : String
    public let WineVariety : String
    public let purchaseDate : String
    public let purchasePrice : Int
    public let period : Int
}
