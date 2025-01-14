// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import SwiftData

@Model
public class UserData {
    @Attribute(.unique) public var userId : Int
    // 유저 프로필 저장
    @Relationship public var userInfo : PersonalData?
    @Relationship public var wines : [WineList] = [] // 홈에서 사용하는 와인
    @Relationship public var controllerCounters: [APIControllerCounter] = [] // API 호출 횟수 기록
    @Relationship public var wishlist: Wishlist? // 위시리스트 와인 저장
    @Relationship public var tastingNoteList: [TastingNoteData] = [] // 테이스팅 노트 저장
    // 보유와인 저장
    
    public init(userId: Int,
         personalInfo : PersonalData? = nil,
         wines: [WineList] = [],
         controllerCounters: [APIControllerCounter] = [],
         wishlist: Wishlist? = nil) {
        self.userId = userId
        self.userInfo = personalInfo
        self.wines = wines
        self.controllerCounters = controllerCounters
        self.wishlist = wishlist
    }
}

@Model
public class PersonalData {
    @Attribute public var userName: String?
    @Attribute public var userImageURL: String?
    @Attribute public var userCity: String?
    @Attribute public var authType : String?
    
    @Relationship var user: UserData?
    
    
    public init(userName: String? = nil,
                userImageURL: String? = nil,
                userCity: String? = nil,
                authType: String? = nil,
                userData: UserData? = nil
    ) {
        self.userName = userName
        self.userImageURL = userImageURL
        self.userCity = userCity
        self.authType = authType
        self.user = userData
    }
    
}
