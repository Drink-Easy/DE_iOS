// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import UIKit

public class UserSurveyManager {
    public static let shared = UserSurveyManager()
    
    public var name: String = ""
    public var region: String = ""
    public var imageData: UIImage?
    
    public var isNewbie: Bool = true
    public var monthPrice: Int = 0
    public var wineSort : [String] = []
    public var wineArea: [String] = []
    public var wineVariety : [String] = []
    
    public var drinkVarietyResult: [DrinkVariety] = []
    public var drinkSortResult: [DrinkSort] = []
    public var foodVarietyResult: [DrinkVariety] = []
    public var foodSortResult: [DrinkSort] = []
    
    public var unionSortData = Set<DrinkSort>()
    public var unionVarietyData = Set<DrinkVariety>()
    public var intersectionSortData = Set<DrinkSort>()
    public var intersectionVarietyData = Set<DrinkVariety>()
    
    private init() {}
    
    public func setNewbieResult() {
        self.wineSort = self.getIntersectionSortData()
        self.wineVariety = self.getIntersectionVarietyData()
    }
    
    public func setPersonalInfo(name : String, profileImg image : UIImage? = nil) {
        self.name = name
        self.imageData = image
    }
    
    public func setUserType(isNewbie : Bool) {
        self.isNewbie = isNewbie
    }
    
    public func setPrice(_ price: Int) {
        self.monthPrice = price
    }
    
    public func setSort(_ wines: [String]) {
        self.wineSort = wines
    }
    
    public func setArea(_ wines: [String]) {
        self.wineArea = wines
    }
    
    public func setVariety(_ wines: [String]) {
        self.wineVariety = wines
    }
    
    public func union() {
        unionVarietyData.removeAll()
        unionVarietyData.formUnion(drinkVarietyResult)
        unionVarietyData.formUnion(foodVarietyResult)
        
        unionSortData.removeAll()
        unionSortData.formUnion(drinkSortResult)
        unionSortData.formUnion(foodSortResult)
    }
    
    public func intersection() {
        intersectionVarietyData = Set(drinkVarietyResult).intersection(Set(foodVarietyResult))
        intersectionSortData = Set(drinkSortResult).intersection(Set(foodSortResult))
    }
    
    public func getIntersectionVarietyData() -> [String] {
        var arr: [String] = []
        intersectionVarietyData.forEach {
            arr.append($0.rawValue)
        }
        return arr
    }
    
    public func getIntersectionSortData() -> [String] {
        var arr: [String] = []
        intersectionSortData.forEach {
            arr.append($0.rawValue)
        }
        return arr
    }
    
    public func getUnionVarietyData() -> [String] {
        var arr: [String] = []
        unionVarietyData.forEach {
            arr.append($0.rawValue)
        }
        return arr
    }
    
    public func getUnionSortData() -> [String] {
        var arr: [String] = []
        unionSortData.forEach {
            arr.append($0.rawValue)
        }
        return arr
    }
    
    public func resetData() {
        name = ""
        region = ""
        imageData = nil
        isNewbie = true
        monthPrice = 0
        wineSort = []
        wineArea = []
        wineVariety = []

        drinkVarietyResult = []
        drinkSortResult = []
        foodVarietyResult = []
        foodSortResult = []

        unionSortData.removeAll()
        unionVarietyData.removeAll()
        intersectionSortData.removeAll()
        intersectionVarietyData.removeAll()
    }
    
    public func calculateDrinkType(_ drinks: [String]) {
        for drink in drinks {
            if drink.contains(DrinkType.소주.rawValue) {
                drinkVarietyResult += [.소비뇽블랑, .말벡, .피노그리지오, .카베르네소비뇽]
                drinkSortResult += [.레드, .화이트]
            } else if drink.contains(DrinkType.맥주.rawValue) {
                drinkVarietyResult += [.모스카토, .소비뇽블랑,]
                drinkSortResult += [.화이트, .로제, .스파클링]
            } else if drink.contains(DrinkType.위스키.rawValue) {
                drinkVarietyResult += [.피노누아, .쉬라즈, .산지오베제, .샤도네이]
                drinkSortResult += [.레드, .화이트]
            } else if drink.contains(DrinkType.칵테일.rawValue) {
                drinkVarietyResult += [.모스카토, .샤도네이, .리슬링,]
                drinkSortResult += [.화이트, .로제, .스파클링]
            } else if drink.contains(DrinkType.막걸리.rawValue) {
                drinkVarietyResult += [.모스카토, .소비뇽블랑,]
                drinkSortResult += [.화이트, .로제, .스파클링]
            } else if drink.contains(DrinkType.사케.rawValue) {
                drinkVarietyResult += [.모스카토, .소비뇽블랑, .피노그리지오,]
                drinkSortResult += [.화이트, .로제, .스파클링]
            } else if drink.contains(DrinkType.브랜디.rawValue) {
                drinkVarietyResult += [.피노누아, .쉬라즈, .산지오베제, .메를로]
                drinkSortResult += [.레드]
            } else {
                drinkVarietyResult += [.말벡, .카베르네소비뇽]
                drinkSortResult += [.레드]
            }
        }
    }
    
    public func calculateFoodType(_ foods: [String]) {
        for food in foods {
            if food.contains(FoodType.육류.rawValue) {
                foodVarietyResult += [.말벡, .카베르네소비뇽, .피노누아, .쉬라즈, .메를로]
                foodSortResult += [.레드]
            } else if food.contains(FoodType.해산물.rawValue) {
                foodVarietyResult += [.소비뇽블랑, .피노그리지오, .샤도네이, .리슬링]
                foodSortResult += [.화이트]
            } else if food.contains(FoodType.치즈.rawValue) {
                foodVarietyResult += [.소비뇽블랑, .카베르네소비뇽, .피노누아, .쉬라즈, .샤도네이, .리슬링, .보르도]
                foodSortResult += [.레드, .화이트, .스파클링]
            } else if food.contains(FoodType.스낵.rawValue) {
                foodVarietyResult += [.소비뇽블랑, .말벡, .피노그리지오, .쉬라즈, .샤도네이]
                foodSortResult += [.레드, .화이트, .로제]
            } else if food.contains(FoodType.피자.rawValue) {
                foodVarietyResult += [.말벡, .피노그리지오, .카베르네소비뇽, .쉬라즈, .산지오베제,  .샤도네이, .리슬링]
                foodSortResult += [.레드, .화이트]
            } else if food.contains(FoodType.디저트.rawValue) {
                foodVarietyResult += [.모스카토]
                foodSortResult += [.스파클링]
            }
        }
    }
    
}

public enum DrinkType: String {
    case 소주, 맥주, 위스키, 칵테일, 막걸리, 사케, 고량주, 보드카, 브랜디, 데킬라
}

public enum FoodType: String {
    case 육류, 해산물, 치즈, 스낵, 피자, 디저트
}

public enum DrinkVariety: String {
    case 소비뇽블랑 = "소비뇽 블랑"
    case 말벡 = "말벡"
    case 피노그리지오 = "피노 그리지오"
    case 카베르네소비뇽 = "카베르네 소비뇽"
    case 모스카토 = "모스카토"
    case 피노누아 = "피노 누아"
    case 쉬라즈 = "시라/쉬라즈"
    case 산지오베제 = "산지오베제"
    case 샤도네이 = "샤도네이"
    case 메를로 = "메를로"
    case 리슬링 = "리슬링"
    case 보르도 = "보르도"
    case 카베르네프랑 = "카베르네 프랑"
    case 쁘띠베르도 = "쁘띠 베르도"
    case 그르나슈 = "그르나슈"
    case 블렌드 = "블렌드"
    case 네비올로 = "네비올로"
    case 카르메네르 = "카르메네르"
    case 무르베드르 = "무르베드르"
    case 템프라니요 = "템프라니요"
}

public enum DrinkSort: String {
    case 레드 = "레드"
    case 화이트 = "화이트"
    case 로제 = "로제"
    case 스파클링 = "스파클링"
    case 주정강화 = "주정강화"
    case 내추럴 = "내추럴"
}

