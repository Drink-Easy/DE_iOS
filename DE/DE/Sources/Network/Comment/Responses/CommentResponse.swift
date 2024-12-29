// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct CommentResponseDTO : Decodable {
    public let id : Int
    public let partyId : Int
    public let memeberName : String
    public let content : String
    public let recomments : [RecommentResponseDTO]
    public let timeAgo : String
    public let createdDate : String
    public let deleted : Bool
}
