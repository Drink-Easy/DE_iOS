// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import DesignSystem

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
    
    /// 특정 텍스트의 색상을 변경한 `NSAttributedString` 반환
    public func withColor(for text: String, color: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        if let range = self.range(of: text) {
            let nsRange = NSRange(range, in: self)
            attributedString.addAttribute(.foregroundColor, value: color, range: nsRange)
        }
        
        return attributedString
    }
    
    /// "yyyy-MM-dd'T'HH:mm:ss.SSSZ" 또는 "yyyy-MM-dd'T'HH:mm:ss" 형식의 날짜 문자열을
    /// "yyyy.MM.dd" 형식으로 변환합니다.
    /// - Returns: 변환된 문자열. 변환에 실패하면 nil을 반환합니다.
    func toFlexibleDotFormattedDate() -> String? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        // 시도할 날짜 형식들을 배열로 정의합니다.
        let dateFormats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
            "yyyy-MM-dd'T'HH:mm:ss"
        ]
        
        var date: Date?
        // 정의된 형식들을 순서대로 시도합니다.
        for format in dateFormats {
            formatter.dateFormat = format
            if let d = formatter.date(from: self) {
                date = d
                break // 성공하면 루프를 빠져나옵니다.
            }
        }
        
        // 날짜 변환에 성공한 경우에만 원하는 형식으로 변경합니다.
        guard let finalDate = date else {
            return nil
        }
        
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: finalDate)
    }
}
