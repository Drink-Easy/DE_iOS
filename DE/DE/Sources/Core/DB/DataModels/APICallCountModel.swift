// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import SwiftData

@Model
public class APICounter {
    public var postCount: Int = 0
    public var deleteCount: Int = 0
    public var patchCount: Int = 0

    init(postCount: Int = 0, deleteCount: Int = 0, patchCount: Int = 0) {
        self.postCount = postCount
        self.deleteCount = deleteCount
        self.patchCount = patchCount
    }

    /// POST 호출 카운트 증가
    func incrementPost() {
        postCount += 1
    }

    /// DELETE 호출 카운트 증가
    func incrementDelete() {
        deleteCount += 1
    }

    /// PATCH 호출 카운트 증가
    func incrementPatch() {
        patchCount += 1
    }
}

@Model
public class APIControllerCounter {
    @Attribute(.unique) var name: String
    @Relationship var counter: APICounter // APICounter와 연관 관계 설정
    @Relationship public var user: UserData? // 부모 관계 추가

    init(name: EndpointType, counter: APICounter, user: UserData? = nil) {
        self.name = name.rawValue
        self.counter = counter
        self.user = user
    }
}

public enum EndpointType: String, Codable {
    case myWine = "myWine"
    case wishlist = "wishlist"
    case member = "member"
    case tastingNote = "tastingNote"
}
