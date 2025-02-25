// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

class TNWineDataManager {
    // MARK: - Properties
    static let shared = TNWineDataManager()
    
    var wineId: Int
    var wineName: String
    var sort: String
    var country: String
    var region: String
    var imageUrl: String
    var variety: String
    
    // MARK: - Initializer
    public init(
        wineId: Int = 0,
        wineName: String = "",
        sort: String = "",
        country: String = "",
        region: String = "",
        imageUrl: String = "",
        variety: String = ""
    ) {
        self.wineId = wineId
        self.wineName = wineName
        self.sort = sort
        self.country = country
        self.region = region
        self.imageUrl = imageUrl
        self.variety = variety
    }
    
    // MARK: - Methods
    func updateWineData(
        wineId: Int? = nil,
        wineName: String? = nil,
        sort: String? = nil,
        country: String? = nil,
        region: String? = nil,
        imageUrl: String? = nil,
        variety: String? = nil
    ) {
        if let wineId = wineId { self.wineId = wineId }
        if let wineName = wineName { self.wineName = wineName }
        if let sort = sort { self.sort = sort }
        if let country = country { self.country = country }
        if let region = region { self.region = region }
        if let imageUrl = imageUrl { self.imageUrl = imageUrl }
        if let variety = variety { self.variety = variety }
    }
    
    func resetData() {
        wineId = 0
        wineName = ""
        sort = ""
        country = ""
        region = ""
        imageUrl = ""
        variety = ""
    }
    
}

