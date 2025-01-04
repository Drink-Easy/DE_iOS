// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

extension String {
    public func numberOfLines(width: CGFloat, font: UIFont, lineSpacing: CGFloat = 0) -> Int {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let attributedText = NSAttributedString(
            string: self,
            attributes: [
                .font: font,
                .paragraphStyle: paragraphStyle
            ]
        )
        
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = attributedText.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            context: nil
        )
        
        // 줄 수 계산: (전체 높이 ÷ 라인 높이)
        let lineHeight = font.lineHeight + lineSpacing
        return Int(ceil(boundingBox.height / lineHeight))
    }
    
    // 텍스트의 높이를 반환
    public func heightWithConstrainedWidth(width: CGFloat, font: UIFont, lineSpacing: CGFloat = 0) -> CGFloat {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        
        let attributedText = NSAttributedString(
            string: self,
            attributes: [
                .font: font,
                .paragraphStyle: paragraphStyle
            ]
        )
        
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = attributedText.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            context: nil
        )
        
        // 높이 반환 (lineSpacing 반영)
        return ceil(boundingBox.height)
    }
}
