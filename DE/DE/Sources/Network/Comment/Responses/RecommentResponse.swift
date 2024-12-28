// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public struct RecommentResponseDTO : Decodable {
    public let id : Int
    public let commentId : Int
    public let memberName : String
    public let content : String
    public let timeAgo : String
    public let createdDate : String
}
