// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import UIKit

struct MyOwnedWineModel {
    let wineImage: UIImage
    let wineName: String
    let buyDate: String
    let price: String
}

extension MyOwnedWineModel {
    static func sections() -> [MyOwnedWineModel] {
        return [
            MyOwnedWineModel(wineImage: UIImage(named: "wine1") ?? UIImage(), wineName: "루이 로드레", buyDate: "D+3", price: "78,000"),
            MyOwnedWineModel(wineImage: UIImage(named: "wine1") ?? UIImage(), wineName: "루이 로드레", buyDate: "D+3", price: "78,000"),
            MyOwnedWineModel(wineImage: UIImage(named: "wine1") ?? UIImage(), wineName: "루이 로드레", buyDate: "D+3", price: "78,000")
        ]
    }
}

