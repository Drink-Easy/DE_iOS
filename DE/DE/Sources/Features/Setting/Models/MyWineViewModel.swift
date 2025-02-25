// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct MyWineViewModel {
    public let myWineId : Int
    public let wineId : Int
    public let wineName : String
    public let wineSort : String
    public let wineCountry : String
    public let wineRegion : String
    public let wineVariety : String
    public let wineImageUrl : String
    public let purchaseDate : String
    public let purchasePrice : Int
    public let period : Int
    
    public func getBuyDate() -> DateComponents? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국 시간대 설정
        
        guard let date = dateFormatter.date(from: purchaseDate) else {
            return nil
        }
        
        // Date를 DateComponents로 변환
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return components
    }
}
