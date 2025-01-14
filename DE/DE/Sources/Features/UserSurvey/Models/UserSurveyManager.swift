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
    
}
