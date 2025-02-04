// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import SwiftData

@Model
public class SavedWineDataModel {
    @Attribute(.unique) public var myWineId: Int
    public var wineId: Int
    public var wineName: String
    public var imageURL : String
    public var wineSort : String
    public var wineCountry : String
    public var wineRegion : String
    public var wineVariety : String
    public var price: Int
    public var date: String
    public var Dday: Int
    
    public init(wineId: Int = -1, myWineId: Int = -1, wineName: String = "noname", imageURL: String = "none", wineSort: String = "알 수 없음", wineCountry: String = "알 수 없음", wineRegion: String = "알 수 없음", wineVariety: String = "알 수 없음", price: Int = -1, date: String = "0000-00-00", Dday: Int = -1) {
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
