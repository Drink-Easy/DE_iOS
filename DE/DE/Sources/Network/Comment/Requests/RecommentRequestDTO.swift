// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

struct RecommentRequestDTO: Encodable {
    let commentId : Int
    let content : String
    
    init(commentId: Int, content: String) {
        self.commentId = commentId
        self.content = content
    }
}
