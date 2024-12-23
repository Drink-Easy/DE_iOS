// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

struct CommentRequestDTO : Codable {
    let partId : Int
    let content : String
    
    init(partId: Int, content: String) {
        self.partId = partId
        self.content = content
    }
}
