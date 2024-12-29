// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct CommentRequestDTO : Codable {
    public let partId : Int
    public let content : String
    
    public init(partId: Int, content: String) {
        self.partId = partId
        self.content = content
    }
}
