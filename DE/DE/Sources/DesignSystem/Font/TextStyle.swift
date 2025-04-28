// Copyright © 2025 DRINKIG. All rights reserved

import UIKit

public struct TextStyle {
    public let font: UIFont
    public let fontSize: CGFloat
    public let lineHeightMultiple: CGFloat
    public let letterSpacingPercent: CGFloat

    public init(
        font: UIFont,
        fontSize: CGFloat,
        lineHeightMultiple: CGFloat,
        letterSpacingPercent: CGFloat
    ) {
        self.font = font
        self.fontSize = fontSize
        self.lineHeightMultiple = lineHeightMultiple
        self.letterSpacingPercent = letterSpacingPercent
    }

    public func attributed(_ text: String, color: UIColor, alignment: NSTextAlignment = .left) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.minimumLineHeight = fontSize * lineHeightMultiple
        paragraphStyle.maximumLineHeight = fontSize * lineHeightMultiple

        let kern = fontSize * (letterSpacingPercent / 100.0)

        return NSAttributedString(
            string: text,
            attributes: [
                .font: font,
                .foregroundColor: color,
                .paragraphStyle: paragraphStyle,
                .kern: kern
            ]
        )
    }

    public func apply(to label: UILabel, text: String, color: UIColor, alignment: NSTextAlignment = .left) {
        label.attributedText = attributed(text, color: color, alignment: alignment)
    }
}
