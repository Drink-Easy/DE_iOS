// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct NoticeResponse : Decodable {
    public let id : Int
    public let title : String
    public let tag : String
    public let contentUrl: String
    public let createdAt : String
    
    public init(id: Int, title: String, tag: String, contentUrl: String, createdAt: String) {
        self.id = id
        self.title = title
        self.tag = tag
        self.contentUrl = contentUrl
        self.createdAt = createdAt
    }
}
