// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

struct CommentResponseDTO : Decodable {
    let id : Int
    let partyId : Int
    let memeberName : String
    let content : String
    let recomments : [RecommentResponseDTO]
    let timeAgo : String
    let createdDate : String
    let deleted : Bool
}
