// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import UIKit

public class UserSurveyManager {
    public static let shared = UserSurveyManager()
    
    public var name: String = ""
    public var region: String = ""
    public var imageData: UIImage = UIImage()
    
    public var isNewbie: Bool = true
    public var monthPrice: Int = 0
    public var wineSort : [String] = []
    public var wineArea: [String] = []
    public var wineVariety : [String] = []
    
    public var drinkVarietyResult: [String] = []
    public var drinkSortResult: [String] = []
    public var foodVarietyResult: [String] = []
    public var foodSortResult: [String] = []
    
    public var unionSortData = Set<String>()
    public var unionVarietyData = Set<String>()
    public var intersectionSortData = Set<String>()
    public var intersectionVarietyData = Set<String>()
    
    private init() {}
    
    
    public func setPersonalInfo(name : String, addr region: String, profileImg image : UIImage) {
        self.name = name
        self.region = region
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
    
    public func calculateDrinkType(_ drinks: [String]) {
        for drink in drinks {
            switch drink {
            case "소주":
                drinkVarietyResult.append("소비뇽 블랑")
                drinkVarietyResult.append("말벡")
                drinkVarietyResult.append("피노 그리지오")
                drinkVarietyResult.append("카베르네 소비뇽")
                
                drinkSortResult += ["레드", "화이트"]
            case "맥주":
                drinkVarietyResult.append("모스카토")
                drinkVarietyResult.append("까바")
                drinkVarietyResult.append("소비뇽 블랑")
                drinkVarietyResult.append("로제 스파클링")
                drinkSortResult += ["화이트", "로제", "스파클링"]
            case "위스키":
                drinkVarietyResult.append("피노 누아")
                drinkVarietyResult.append("쉬라즈")
                drinkVarietyResult.append("산지오배제")
                drinkVarietyResult.append("샤도네이")
                drinkVarietyResult.append("샴페인")
                drinkSortResult += ["레드", "화이트"]
            case "칵테일":
                drinkVarietyResult.append("모스카토")
                drinkVarietyResult.append("까바")
                drinkVarietyResult.append("샤도네이")
                drinkVarietyResult.append("리슬링")
                drinkVarietyResult.append("로제 스파클링")
                drinkSortResult += ["화이트", "로제", "스파클링"]
            case "막걸리":
                drinkVarietyResult.append("모스카토")
                drinkVarietyResult.append("까바")
                drinkVarietyResult.append("소비뇽 블랑")
                drinkVarietyResult.append("로제 스파클링")
                drinkSortResult += ["화이트", "로제", "스파클링"]
            case "사케":
                drinkVarietyResult.append("모스카토")
                drinkVarietyResult.append("소비뇽 블랑")
                drinkVarietyResult.append("피노 그리지오")
                drinkVarietyResult.append("샴페인")
                drinkSortResult += ["화이트", "로제", "스파클링"]
            case "고량주":
                drinkVarietyResult.append("말벡")
                drinkVarietyResult.append("카베르네 소비뇽")
                drinkSortResult += ["레드"]
            case "보드카":
                drinkVarietyResult.append("말벡")
                drinkVarietyResult.append("카베르네 소비뇽")
                drinkSortResult += ["레드"]
            case "브랜디":
                drinkVarietyResult.append("피노 누아")
                drinkVarietyResult.append("쉬라즈")
                drinkVarietyResult.append("산지오배제")
                drinkVarietyResult.append("메를로")
                drinkSortResult += ["레드"]
            case "데킬라":
                drinkVarietyResult.append("말벡")
                drinkVarietyResult.append("카베르네 소비뇽")
                drinkSortResult += ["레드"]
            default :
                print("잘못된 선택지입니다.")
            }
        }
        
        
    }
    
    
    let cellData = ["육류 (스테이크, 바비큐, 치킨 등)", "해산물 (회, 새우, 랍스터 등)", "치즈", "스낵 (견과류, 올리브, 프로슈토 등)", "피자, 파스타", "디저트"]
    // TODO : enum으로 바꿔서 처리하기
    // TODO : 계산 함수 만들기
    
    // TODO : 합집합, 교집합 계산
}

