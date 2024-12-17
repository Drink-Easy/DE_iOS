//
//  ChooseNose.swift
//  Drink-EG
//
//  Created by 이수현 on 12/17/24.
//

import Foundation

struct ChooseNose: Hashable {
    var title: String
    var subItems: [ChooseNose]
    var item: AnyHashable?
}
