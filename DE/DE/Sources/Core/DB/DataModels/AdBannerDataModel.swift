// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import SwiftData

@Model
public class AdBannerDataModel {
    @Relationship(.unique) public var bannerId : Int
    @Attribute public var imageUrl : String
    @Attribute public var postUrl : String
    
    public init(bannerId: Int, imageUrl: String, postUrl: String) {
        self.bannerId = bannerId
        self.imageUrl = imageUrl
        self.postUrl = postUrl
    }
}


@Model
public class AdBannerList {
    @Relationship public var wineList: [AdBannerDataModel] = []
    @Attribute var timestamp: Date?
    
    init(wineList: [AdBannerDataModel], timestamp: Date? = nil) {
        self.wineList = wineList
        self.timestamp = timestamp
    }
}
