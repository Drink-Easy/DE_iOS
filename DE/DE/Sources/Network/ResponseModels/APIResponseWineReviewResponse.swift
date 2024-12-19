//
//  APIResponseWineReviewResponse.swift
//  Drink-EG
//
//  Created by 이현주 on 8/17/24.
//

import Foundation

struct APIResponseWineReviewResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [WineReview]
}
