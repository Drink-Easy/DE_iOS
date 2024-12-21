//
//  AllNotesResponse.swift
//  Drink-EG
//
//  Created by 김도연 on 8/27/24.
//

import Foundation

struct AllNotesResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [Note]
}
