// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

extension UILabel {
    /// 텍스트의 특정 부분의 색상과 크기를 변경합니다.
    /// - Parameters:
    ///   - text: 전체 텍스트
    ///   - targetText: 스타일을 변경할 대상 텍스트
    ///   - color: 변경할 텍스트 색상
    ///   - font: 변경할 텍스트 폰트
    public func setPartialTextStyle(text: String, targetText: String, color: UIColor, font: UIFont) {
        let attributedString = NSMutableAttributedString(string: text)
        
        if let range = text.range(of: targetText) {
            let nsRange = NSRange(range, in: text)
            attributedString.addAttributes(
                [
                    .foregroundColor: color,
                    .font: font
                ],
                range: nsRange
            )
        }
        
        self.attributedText = attributedString
    }
    
    public func setLineSpacingPercentage(_ lineSpacingMultiplier: CGFloat) {
        guard let text = self.text, let font = self.font else { return }
        
        let calculatedLineSpacing = font.pointSize * lineSpacingMultiplier
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = calculatedLineSpacing
        paragraphStyle.lineBreakMode = .byTruncatingTail
        
        let attributedText = NSAttributedString(
            string: text,
            attributes: [
                .font: font,
                .paragraphStyle: paragraphStyle
            ]
        )
        
        self.attributedText = attributedText
    }
    
    /// 행간(Line Spacing)을 조절하는 함수
    /// - Parameters:
    ///   - lineSpacing: 원하는 행간 (기본값: 4)
    ///   - alignment: 텍스트 정렬 방식 (기본값: `.left`)
    public func setLineSpacing(lineSpacing: CGFloat = 4, alignment: NSTextAlignment = .left, font: UIFont = .ptdRegularFont(ofSize: 16)) {
        guard let text = self.text, !text.isEmpty else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = alignment
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: font,
            .foregroundColor: self.textColor ?? UIColor.black, // ✅ 기존 텍스트 색상 유지
            .kern: attributedText?.attribute(.kern, at: 0, effectiveRange: nil) ?? 0 // ✅ 기존 자간 유지
        ]
        
        let attributedString = NSMutableAttributedString(string: text, attributes: attributes)
        
        // ✅ 기존 AttributedText가 있다면 속성 유지 (ex: 특정 글자 색상 다르게 적용한 경우)
        if let existingAttributedText = self.attributedText {
            existingAttributedText.enumerateAttributes(in: NSRange(location: 0, length: existingAttributedText.length), options: []) { attrs, range, _ in
                attributedString.addAttributes(attrs, range: range)
            }
        }
        
        self.attributedText = attributedString
    }
}

