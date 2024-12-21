// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

struct RecommentResponseDTO : Decodable {
    let id : Int
    let commentId : Int
    let memberName : String
    let content : String
    let timeAgo : String
    let createdDate : String
}
