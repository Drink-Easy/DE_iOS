//
//  APIResponseWineInfoResponse.swift
//  Drink-EG
//
//  Created by 이현주 on 8/16/24.
//

import Foundation

struct APIResponseWineInfoResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: WineInfo
}
