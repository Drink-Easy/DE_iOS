// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

public struct SearchResultModel {
    public let wineId: Int
    public let wineName: String
    public let imageURL: String
    public let sort: String
    public let satisfaction: Double
    public let area: String
    
    public init(wineId: Int, wineName: String, imageURL: String, sort: String, satisfaction: Double, area: String) {
        self.wineId = wineId
        self.wineName = wineName
        self.imageURL = imageURL
        self.sort = sort
        self.satisfaction = satisfaction
        self.area = area
    }
}
