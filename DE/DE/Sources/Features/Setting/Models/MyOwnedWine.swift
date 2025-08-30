// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

public struct MyOwnedWine {
    public var wineId: Int
    public var wineName: String
    public var vintage: Int?
    public var price: String
    public var buyDate: String
    public var Dday : Int = 0
    
    public init(
        wineId: Int = 0,
        wineName: String = "",
        vintage: Int? = nil,
        price: String = "",
        buyDate: String = ""
    ) {
        self.wineId = wineId
        self.wineName = wineName
        self.vintage = vintage
        self.price = price
        self.buyDate = buyDate
    }
    
    // 업데이트 메서드
    public mutating func updateWine(
        wineId: Int? = nil,
        wineName: String? = nil,
        vintage: Int? = nil,
        price: String? = nil,
        buyDate: String? = nil
    ) {
        if let wineId = wineId { self.wineId = wineId }
        if let wineName = wineName { self.wineName = wineName }
        if let vintage = vintage { self.vintage = vintage }
        if let price = price { self.price = price }
        if let buyDate = buyDate { self.buyDate = buyDate }
    }
    
    public func getBuyDate() -> DateComponents? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        
        guard let date = dateFormatter.date(from: buyDate) else {
            return nil
        }
        
        // Date를 DateComponents로 변환
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return components
    }
}

public class MyOwnedWineManager {
    
    // 싱글톤 인스턴스
    public static let shared = MyOwnedWineManager()
    
    // 관리할 와인 데이터
    private var wine: MyOwnedWine = MyOwnedWine()
    
    // MARK: - 초기화 방지
    private init() {}
    
    // MARK: - 와인 데이터 관리 메서드
    
    /// 현재 와인 데이터를 반환
    public func getWine() -> MyOwnedWine {
        return wine
    }
    
    /// 와인 ID 설정
    public func setWineId(_ wineId: Int) {
        wine.wineId = wineId
    }
    
    /// 와인 이름 설정
    public func setWineName(_ wineName: String) {
        wine.wineName = wineName
    }
    
    /// 와인 가격 설정
    public func setPrice(_ price: String) {
        wine.price = price
    }
    
    /// 구매 날짜 설정
    public func setBuyDate(_ buyDate: String) {
        wine.buyDate = buyDate
    }
    
    /// 와인 빈티지 설정
    public func setVintage(_ year: Int) {
        wine.vintage = year
    }
    
    /// 와인 ID 가져오기
    public func getWineId() -> Int {
        return wine.wineId
    }
    
    /// 와인 이름 가져오기(이름 + 빈티지)
    public func getWineName() -> String {
        var fullName: String = wine.wineName
        if let vintage = wine.vintage {
            fullName += " \(vintage)"
        }
        
        return fullName
    }
    
    /// 와인 가격 가져오기
    public func getPrice() -> Int {
        return Int(wine.price) ?? 0
    }
    
    /// 구매 날짜 가져오기
    public func getBuyDate() -> String {
        return wine.buyDate
    }
    
    /// 구매 날짜를 `DateComponents`로 반환
    public func getBuyDateComponents() -> DateComponents? {
        return wine.getBuyDate()
    }
    
    /// 빈티지 연도 반환(Int?)
    public func getVintage() -> Int? {
        return wine.vintage
    }
    
    /// 와인 데이터를 초기화
    public func resetWine() {
        wine = MyOwnedWine()
    }
    
    public func resetVintage() {
        wine.vintage = nil
    }
}
