// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

struct PartyResponseDTO : Decodable {
    let id : Int
    let hostId: Int
    let name: String
    let introduce: String
    let limitMemberNum: Int
    let participateMenberNum : Int
    let partyDate: String
    let admissionFee: Int
    let place: String
    let bookmarkCount : Int
    let createdAt: String
    let bookmarked: Bool
}
