//
//  APIResponseWineNewsResponse.swift
//  Drink-EG
//
//  Created by 김도연 on 8/12/24.
//

import Foundation

struct APIResponseWineNewsResponse : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: WineNewsResponse
}
