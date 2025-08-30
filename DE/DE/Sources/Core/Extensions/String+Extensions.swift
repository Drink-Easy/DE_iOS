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
    
    /// 다양한 ISO 8601 형식의 날짜 문자열을 "yyyy.MM.dd" 형식으로 변환합니다.
    /// - Returns: 변환된 문자열. 변환에 실패하면 nil을 반환합니다.
    func toFlexibleDotFormattedDate() -> String? {
        var date: Date?

        // 1. ISO8601DateFormatter로 우선 파싱 시도 (가장 안정적)
        // .withFractionalSeconds 옵션은 소수점 초가 없는 케이스도 처리 가능합니다.
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let parsedDate = isoFormatter.date(from: self) {
            date = parsedDate
        } else {
            // 2. 실패 시, 타임존 정보가 없는 케이스를 위한 폴백(Fallback) 파싱
            // "yyyy-MM-dd'T'HH:mm:ss" 형식을 UTC로 간주하여 처리합니다.
            let fallbackFormatter = DateFormatter()
            fallbackFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            fallbackFormatter.locale = Locale(identifier: "en_US_POSIX")
            fallbackFormatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC로 가정
            
            if let parsedDate = fallbackFormatter.date(from: self) {
                date = parsedDate
            }
        }

        // 3. 파싱에 성공한 경우, 최종 출력 형식으로 변환
        //    어떤 방식으로 파싱되었든, 출력은 항상 동일한 포맷터를 사용합니다.
        guard let finalDate = date else {
            return nil // 모든 파싱 실패
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy.MM.dd"
        outputFormatter.timeZone = .current // 출력은 현재 시간대 기준으로
        return outputFormatter.string(from: finalDate)
    }
}
