// Copyright © 2025 DRINKIG. All rights reserved

import UIKit

public enum AppTextStyle {
    public enum KR {
        public static let head = TextStyle(
            font: UIFont.pretendard(.semiBold, size: 24),
            fontSize: 24,
            lineHeightMultiple: 1.45,
            letterSpacingPercent: -2.5
        )

        public static let subtitle1 = TextStyle(
            font: UIFont.pretendard(.semiBold, size: 20),
            fontSize: 20,
            lineHeightMultiple: 1.5,
            letterSpacingPercent: -2.5
        )
        
        public static let body1 = TextStyle(
            font: UIFont.pretendard(.semiBold, size: 16),
            fontSize: 16,
            lineHeightMultiple: 1.5,
            letterSpacingPercent: -2.5
        )
        
        public static let body2 = TextStyle(
            font: UIFont.pretendard(.semiBold, size: 14),
            fontSize: 14,
            lineHeightMultiple: 1.5,
            letterSpacingPercent: -2.5
        )
    }

    public enum EN {
        public static let title = TextStyle(
            font: UIFont.pretendard(.semiBold, size: 20),
            fontSize: 20,
            lineHeightMultiple: 1.5,
            letterSpacingPercent: 0
        )
        
        public static let subtitle = TextStyle(
            font: UIFont.pretendard(.semiBold, size: 18),
            fontSize: 18,
            lineHeightMultiple: 1.5,
            letterSpacingPercent: 0
        )

        public static let body = TextStyle(
            font: UIFont.pretendard(.semiBold, size: 16),
            fontSize: 16,
            lineHeightMultiple: 1.5,
            letterSpacingPercent: 0
        )
    }
}
