// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import SwiftData

@Model
public class PersonalData {
    @Attribute public var userName: String?
    @Attribute public var userImageURL: String?
    @Attribute public var userCity: String?
    @Attribute public var authType : String?
    @Attribute public var email : String?
    @Attribute public var adult : Bool?
    
    @Relationship var user: UserData?
    
    public init(userName: String? = nil,
                userImageURL: String? = nil,
                userCity: String? = nil,
                authType: String? = nil,
                email: String? = nil,
                adult: Bool? = nil,
                user: UserData? = nil) {
        self.userName = userName
        self.userImageURL = userImageURL
        self.userCity = userCity
        self.authType = authType
        self.email = email
        self.adult = adult
        self.user = user
    }
    
    /// `PersonalData`의 프로퍼티 중 하나라도 nil 값이 있으면 true 반환
    func hasNilProperty() -> Bool {
        return userName == nil || userImageURL == nil || userCity == nil || authType == nil || email == nil || adult == nil
    }
    
    func checkTwoProperty() -> Bool {
        return userName == nil || userImageURL == nil
    }
    
}
