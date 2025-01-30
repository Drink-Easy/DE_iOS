// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import SwiftData

@Model
public class SavedWineDataModel {
    @Attribute(.unique) public var myWineId: Int
    @Attribute public var wineId: Int
    @Attribute public var wineName: String
    @Attribute public var imageURL : String
    @Attribute public var wineSort : String
    @Attribute public var wineCountry : String
    @Attribute public var wineRegion : String
    @Attribute public var wineVariety : String
    @Attribute public var price: Int
    @Attribute public var date: String
    @Attribute public var Dday: Int
    
    public init(wineId: Int, myWineId: Int, wineName: String, imageURL: String, wineSort: String, wineCountry: String, wineRegion: String, wineVariety: String, price: Int, date: String, Dday: Int) {
        self.wineId = wineId
        self.myWineId = myWineId
        self.wineName = wineName
        self.imageURL = imageURL
        self.wineSort = wineSort
        self.wineCountry = wineCountry
        self.wineRegion = wineRegion
        self.wineVariety = wineVariety
        self.price = price
        self.date = date
        self.Dday = Dday
    }

}

/// 보유와인 리스트
@Model
public class MyWineList {
    @Relationship var wineList: [SavedWineDataModel] = []
    @Attribute var timestamp: Date?
    @Relationship var user: UserData?
    
    public init(wineList: [SavedWineDataModel], timestamp: Date? = nil, user: UserData? = nil) {
        self.wineList = wineList
        self.timestamp = timestamp
        self.user = user
    }
}
