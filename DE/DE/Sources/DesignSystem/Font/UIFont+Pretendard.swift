// Copyright © 2025 DRINKIG. All rights reserved

import UIKit

public extension UIFont {
    enum Pretendard: String {
        case black = "Pretendard-Black"
        case bold = "Pretendard-Bold"
        case extraBold = "Pretendard-ExtraBold"
        case extraLight = "Pretendard-ExtraLight"
        case light = "Pretendard-Light"
        case medium = "Pretendard-Medium"
        case regular = "Pretendard-Regular"
        case semiBold = "Pretendard-SemiBold"
        case thin = "Pretendard-Thin"
    }
    
    // pretendard 폰트 적용
    static func pretendard(_ style: Pretendard, size: CGFloat) -> UIFont {
        return UIFont(name: style.rawValue, size: size) ?? .systemFont(ofSize: size)
    }
    
}
