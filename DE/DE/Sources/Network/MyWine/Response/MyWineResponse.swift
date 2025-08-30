// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct MyWineResponse : Decodable {
    public let myWineId : Int
    public let wineId : Int
    public let wineName : String
    public let vintageYear : Int?
    public let wineSort : String
    public let wineCountry : String
    public let wineRegion : String
    public let wineVariety : String
    public let wineImageUrl : String
    public let purchaseDate : String
    public let purchasePrice : Int
    public let period : Int
    
    public init(
        myWineId: Int,
        wineId: Int,
        wineName: String,
        vintageYear: Int? = nil,
        wineSort: String,
        wineCountry: String,
        wineRegion: String,
        wineVariety: String,
        wineImageUrl: String,
        purchaseDate: String,
        purchasePrice: Int,
        period: Int
    ) {
        self.myWineId = myWineId
        self.wineId = wineId
        self.wineName = wineName
        self.vintageYear = vintageYear
        self.wineSort = wineSort
        self.wineCountry = wineCountry
        self.wineRegion = wineRegion
        self.wineVariety = wineVariety
        self.wineImageUrl = wineImageUrl
        self.purchaseDate = purchaseDate
        self.purchasePrice = purchasePrice
        self.period = period
    }
}
