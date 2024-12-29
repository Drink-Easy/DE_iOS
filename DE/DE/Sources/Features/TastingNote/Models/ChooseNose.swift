// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

struct ChooseNose: Hashable {
    var title: String
    var subItems: [ChooseNose]
    var item: AnyHashable?
}
