// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

struct PartyRequestDTO: Codable {
    let hostId: Int
    let name: String
    let introduce: String
    let limitMemberNum: Int
    let participateMemberNum: Int
    let partyDate: String
    let admissionFee: Int
    let place : String
    let createAt: String
}
