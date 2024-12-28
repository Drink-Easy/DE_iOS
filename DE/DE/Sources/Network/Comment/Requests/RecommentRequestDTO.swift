// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct RecommentRequestDTO: Encodable {
    public let commentId : Int
    public let content : String
    
    public init(commentId: Int, content: String) {
        self.commentId = commentId
        self.content = content
    }
}
