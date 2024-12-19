//
//  WineReviewResponse.swift
//  Drink-EG
//
//  Created by 이현주 on 8/17/24.
//

import Foundation

struct WineReview: Decodable {
    
    let name: String
    let satisfaction: Double
    let review: String
}
