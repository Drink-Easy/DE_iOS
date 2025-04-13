// Copyright © 2025 DRINKIG. All rights reserved

import UIKit

public extension NSAttributedString {
    
    /// 지정된 폰트 스타일과 줄 간격, 색상을 적용한 `NSAttributedString`을 생성합니다.
    ///
    /// - Parameters:
    ///   - text: 스타일을 적용할 문자열입니다.
    ///   - font: 사용할 `UIFont.Pretendard` 스타일입니다.
    ///   - size: 폰트 크기입니다.
    ///   - lineHeight: 줄 간격입니다.
    ///   - color: 텍스트 색상입니다. 기본값은 `.label`입니다.
    ///   - alignment: 정렬 방식입니다. 기본값은 `.left`입니다.
    /// - Returns: 스타일이 적용된 `NSAttributedString` 객체입니다.
    static func pretendard(
        _ text: String,
        font: UIFont.Pretendard,
        size: CGFloat,
        lineHeight: CGFloat,
        color: UIColor = .label,
        alignment: NSTextAlignment = .left
    ) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = lineHeight
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.alignment = alignment

        return NSAttributedString(
            string: text,
            attributes: [
                .font: UIFont(name: font.rawValue, size: size) ?? .systemFont(ofSize: size),
                .foregroundColor: color,
                .paragraphStyle: paragraphStyle
            ]
        )
    }
}
