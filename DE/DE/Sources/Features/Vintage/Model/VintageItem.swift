// Copyright © 2025 DRINKIG. All rights reserved

import UIKit
import CoreModule

// MARK: - VintageItem
// SectionItem 프로토콜을 구현하여 ExpandableHeaderView에서 사용할 수 있도록 함
struct VintageItem: SectionItem {
    let year: Int
    let score: Double
    
    var displayText: String { "\(year)" }
    var accessoryText: String? { "★ \(String(format: "%.1f", score))" }
}
