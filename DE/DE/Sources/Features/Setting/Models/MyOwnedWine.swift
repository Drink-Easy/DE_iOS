// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

public struct MyOwnedWine {
    public var wineId: Int
    public var wineName: String
    public var price: String
    public var buyDate: String
    
    public init(wineId: Int = 0, wineName: String = "", price: String = "", buyDate: String = "") {
        self.wineId = wineId
        self.wineName = wineName
        self.price = price
        self.buyDate = buyDate
    }
    
    // 업데이트 메서드
    public mutating func updateWine(wineId: Int? = nil, wineName: String? = nil, price: String? = nil, buyDate: String? = nil) {
        if let wineId = wineId { self.wineId = wineId }
        if let wineName = wineName { self.wineName = wineName }
        if let price = price { self.price = price }
        if let buyDate = buyDate { self.buyDate = buyDate }
    }
    
    public func getBuyDate() -> DateComponents? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국 시간대 설정
        
        guard let date = dateFormatter.date(from: buyDate) else {
            print("변환할 수 없는 날짜 형식입니다: \(buyDate)")
            return nil
        }
        
        // Date를 DateComponents로 변환
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return components
    }
}


