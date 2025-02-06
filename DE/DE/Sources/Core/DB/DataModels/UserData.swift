// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import SwiftData

@Model
public class UserData {
    @Attribute(.unique) public var userId : Int
    // 유저 프로필 저장
    @Relationship(deleteRule: .cascade) public var userInfo : PersonalData?
    @Relationship(deleteRule: .cascade) public var recommendWineList : RecommendWineList?
    @Relationship(deleteRule: .cascade) public var controllerCounters: [APIControllerCounter] = [] // API 호출 횟수 기록
    @Relationship(deleteRule: .cascade) public var wishlist: Wishlist? // 위시리스트 와인 저장
    @Relationship(deleteRule: .cascade) public var tastingNoteList: TastingNoteList? // 테이스팅 노트 저장
    @Relationship(deleteRule: .cascade) public var savedWineList: MyWineList? // 보유와인 저장
    
    public init(userId: Int, userInfo: PersonalData? = nil, recommendWineList: RecommendWineList? = nil, controllerCounters: [APIControllerCounter] = [], wishlist: Wishlist? = nil, tastingNoteList: TastingNoteList? = nil, savedWineList: MyWineList? = nil) {
        self.userId = userId
        self.userInfo = userInfo
        self.controllerCounters = controllerCounters
        
        // Nil
        self.recommendWineList = recommendWineList
        self.wishlist = wishlist
        self.tastingNoteList = tastingNoteList
        self.savedWineList = savedWineList
    }
}
