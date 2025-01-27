// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import SwiftData

@Model
public class SavedWineDataModel {
    @Attribute public var wineId: Int
    @Attribute public var wineName: String
    @Attribute public var imageURL : String
    @Attribute public var price: Int
    @Attribute public var date: String
    @Attribute public var Dday: Int
    
    public init(wineId: Int, wineName: String, imageURL: String, price: Int, date: String, Dday: Int) {
        self.wineId = wineId
        self.wineName = wineName
        self.imageURL = imageURL
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
