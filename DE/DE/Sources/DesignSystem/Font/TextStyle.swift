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
    
    /// 텍스트에 스타일을 적용하여 `NSMutableAttributedString`을 생성합니다.
    /// - Parameters:
    ///   - text: 스타일을 적용할 문자열
    ///   - color: 텍스트 색상
    ///   - alignment: 텍스트 정렬 방식
    /// - Returns: 스타일이 적용된 `NSMutableAttributedString`
    public func attributed(
        _ text: String,
        color: UIColor,
        alignment: NSTextAlignment = .left
    ) -> NSMutableAttributedString {
        
        // 1. Paragraph Style 설정 (행간, 정렬)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        let desiredLineHeight = fontSize * lineHeightMultiple
        paragraphStyle.minimumLineHeight = desiredLineHeight
        paragraphStyle.maximumLineHeight = desiredLineHeight
        
        // 2. 자간(Kerning) 계산
        let kern = fontSize * (letterSpacingPercent / 100.0)
        
        // 3. 기본 속성(Attribute) 정의
        var attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraphStyle,
            .kern: kern
        ]
        
        // 4. Baseline Offset 계산 및 추가
        //    - 디자인된 행간(desiredLineHeight)과 폰트의 실제 행간(font.lineHeight)의 차이를 계산하여
        //    - 텍스트가 행의 중앙에 오도록 수직 위치를 조정합니다.
        if desiredLineHeight > 0 && desiredLineHeight != font.lineHeight {
            let baselineOffset = (desiredLineHeight - font.lineHeight) / 2.0
            attributes[.baselineOffset] = baselineOffset
        }
        
        // 5. 최종적으로 NSMutableAttributedString을 생성하여 반환
        return NSMutableAttributedString(
            string: text,
            attributes: attributes
        )
    }
    
    public func apply(to label: UILabel, text: String, color: UIColor, alignment: NSTextAlignment = .left) {
        label.attributedText = attributed(text, color: color, alignment: alignment)
    }
}

// 사용법
// AppTextStyle.KR.head.apply(to: largeTitleLabel, text: wineName, color: AppColor.black)
