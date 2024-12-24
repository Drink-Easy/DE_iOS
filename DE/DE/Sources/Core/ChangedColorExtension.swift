// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

extension String {
    /// 특정 텍스트의 색상을 변경한 `NSAttributedString` 반환
    func withColor(for text: String, color: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        if let range = self.range(of: text) {
            let nsRange = NSRange(range, in: self)
            attributedString.addAttribute(.foregroundColor, value: color, range: nsRange)
        }
        
        return attributedString
    }
}
