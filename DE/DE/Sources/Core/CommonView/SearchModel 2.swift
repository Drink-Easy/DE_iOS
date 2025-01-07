//
//  ViewController.swift
//  Basic
//
//  Created by 김도연 on 12/17/24.
//

import UIKit

struct SearchModel {
    
}

struct Wine: Codable {
    let wineId: Int
    let name: String
    let imageUrl: String?
    let rating: Double
    let price: Int
    let area: String
    let sort: String
}

