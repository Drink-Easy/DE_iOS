// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import SwiftData

@Model
public class UserData {
    @Attribute(.unique) public var userId : Int
    public var userName: String?
<<<<<<< Updated upstream
    
    @Relationship public var wines : [WineList] = [] // 홈에서 사용하는 와인
    @Relationship public var controllerCounters: [APIControllerCounter] = [] // API 호출 횟수 기록
    @Relationship public var wishlist: Wishlist? // 위시리스트 와인 저장
    // 테이스팅 노트 저장
    // 보유와인 저장
    
    init(userId: Int, userName: String? = nil, wines: [WineList], controllerCounters: [APIControllerCounter], wishlist: Wishlist? = nil) {
        self.userId = userId
        self.userName = userName
        self.wines = wines
        self.controllerCounters = controllerCounters
        self.wishlist = wishlist
=======
    @Relationship public var wines : [WineList] = []
//        var wishlist: Wishlist
    
    init(userId: Int, userName: String? = nil, wines: [WineList]) {
        self.userId = userId
        self.userName = userName
        self.wines = wines
>>>>>>> Stashed changes
    }
}
