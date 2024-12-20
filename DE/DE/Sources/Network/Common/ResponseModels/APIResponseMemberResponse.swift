//
//  APIResponseMemberResponse.swift
//  Drink-EG
//
//  Created by 김도연 on 8/14/24.
//

import Foundation

struct APIResponseMemberResponse : Codable {
    let isSuccess : Bool
    let code : String
    let message : String
    let result : MemberResponse?
}
