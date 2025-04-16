// Copyright © 2025 DRINKIG. All rights reserved

import UIKit

public extension String {
    /// 특정 부분에 Pretendard 스타일을 강조 적용한 `NSMutableAttributedString` 반환
    func styledTextWithPretendard(
        highlightText: String,
        baseFont: UIFont.Pretendard,
        baseSize: CGFloat,
        highlightFont: UIFont.Pretendard,
        highlightSize: CGFloat,
        lineHeightMultiple: CGFloat = 1.0,
        letterSpacingPercent: CGFloat = 0.0,
        baseColor: UIColor = .label,
        highlightColor: UIColor = .systemGreen,
        alignment: NSTextAlignment = .left
    ) -> NSMutableAttributedString {

        let baseFontInstance = UIFont(name: baseFont.rawValue, size: baseSize) ?? .systemFont(ofSize: baseSize)
        let highlightFontInstance = UIFont(name: highlightFont.rawValue, size: highlightSize) ?? .systemFont(ofSize: highlightSize)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.minimumLineHeight = baseSize * lineHeightMultiple
        paragraphStyle.maximumLineHeight = baseSize * lineHeightMultiple
        
        let letterSpacingInPt = baseSize * (letterSpacingPercent / 100.0)

        let attributedString = NSMutableAttributedString(
            string: self,
            attributes: [
                .font: baseFontInstance,
                .foregroundColor: baseColor,
                .paragraphStyle: paragraphStyle,
                .kern: letterSpacingInPt
            ]
        )

        if let range = self.range(of: highlightText) {
            let nsRange = NSRange(range, in: self)
            attributedString.addAttributes([
                .foregroundColor: highlightColor,
                .font: highlightFontInstance
            ], range: nsRange)
        }

        return attributedString
    }
}
