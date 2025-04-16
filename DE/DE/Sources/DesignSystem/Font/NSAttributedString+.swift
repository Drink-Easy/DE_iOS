// Copyright © 2025 DRINKIG. All rights reserved

import UIKit

public extension NSAttributedString {
    
    /// 주어진 텍스트에 Pretendard 폰트, 줄 간격, 색상, 자간 등을 적용하여 `NSAttributedString`을 생성합니다.
    ///
    /// - Parameters:
    ///   - text: 스타일을 적용할 문자열입니다.
    ///   - font: 사용할 `UIFont.Pretendard` 스타일입니다.
    ///   - size: 폰트 크기 (포인트 단위)입니다.
    ///   - lineHeightMultiple: 줄 간격 비율입니다. 예: `1.5`는 폰트 크기의 150% 줄 간격을 의미합니다.
    ///   - letterSpacingPercent: 자간(문자 간 간격) 비율입니다. 퍼센트 단위이며, 예: `-2`는 폰트 크기의 -2% 자간입니다.
    ///   - color: 텍스트 색상입니다. 기본값은 `.label`입니다.
    ///   - alignment: 텍스트 정렬 방식입니다. 기본값은 `.left`입니다.
    ///
    /// - Returns: 스타일이 적용된 `NSAttributedString` 객체를 반환합니다.
    static func pretendard(
        _ text: String,
        font: UIFont.Pretendard,
        size: CGFloat,
        lineHeightMultiple: CGFloat = 1.0,
        letterSpacingPercent: CGFloat = 0.0,
        color: UIColor = .label,
        alignment: NSTextAlignment = .left
    ) -> NSAttributedString {
        
        let fontInstance = UIFont(name: font.rawValue, size: size) ?? .systemFont(ofSize: size)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        paragraphStyle.minimumLineHeight = size * lineHeightMultiple
        paragraphStyle.maximumLineHeight = size * lineHeightMultiple
        
        let letterSpacingInPt = size * (letterSpacingPercent / 100.0)

        return NSAttributedString(
            string: text,
            attributes: [
                .font: fontInstance,
                .foregroundColor: color,
                .paragraphStyle: paragraphStyle,
                .kern: letterSpacingInPt
            ]
        )
    }
}
