// Copyright © 2025 DRINKIG. All rights reserved

import UIKit
import CoreModule
import DesignSystem
import Then

final class TastingNoteHeaderView: UIView {
    let wineTitleLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.lineBreakStrategy = .hangulWordPriority
    }
    
}
