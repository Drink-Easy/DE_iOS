//
//  ViewController.swift
//  Basic
//
//  Created by 김도연 on 12/17/24.
//

import UIKit

struct HomeWineModel {
    let wineId: Int
    let wineName: String
    let imageURL : String
    
    init(wineId: Int, wineName: String, imageURL: String) {
        self.wineId = wineId
        self.wineName = wineName
        self.imageURL = imageURL
    }
}

