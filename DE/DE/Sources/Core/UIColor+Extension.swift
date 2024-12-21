// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

public struct AppColor {
    static public let purple100 = UIColor(hex: "#7E13B1")
    static public let purple70 = UIColor(hex: "#9741BF")
    static public let purple50 = UIColor(hex: "#B06FCD")
    static public let purple30 = UIColor(hex: "#D5B3E2")
    static public let purple20 = UIColor(hex: "#E1CAE9")
    static public let purple10 = UIColor(hex: "#EEE1F0")
    
    static public let gray100 = UIColor(hex: "#606060")
    static public let gray80 = UIColor(hex: "#A7A7A7")
    static public let gray60 = UIColor(hex: "#DADADA")
    static public let gray40 = UIColor(hex: "#E9E9E9")
    static public let gray20 = UIColor(hex: "#F8F8F8")
    
    static public let black = UIColor(hex: "#121212")
}

public extension UIColor {
    // HEX 문자열을 UIColor로 변환하는 초기화 메서드
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        let length = hexSanitized.count

        let r, g, b, a: CGFloat
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            a = 1.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    
    
//    class func appPurple() -> UIColor {
//        return UIColor(hex: AppColor.wineClassPurple)!
//    }
//
    
//    // HEX 문자열을 UIColor로 변환하는 초기화 메서드
//    convenience init?(hex: String) {
//        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
//        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
//
//        var rgb: UInt64 = 0
//
//        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
//
//        let length = hexSanitized.count
//
//        let r, g, b, a: CGFloat
//        if length == 6 {
//            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
//            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
//            b = CGFloat(rgb & 0x0000FF) / 255.0
//            a = 1.0
//        } else if length == 8 {
//            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
//            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
//            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
//            a = CGFloat(rgb & 0x000000FF) / 255.0
//        } else {
//            return nil
//        }
//
//        self.init(red: r, green: g, blue: b, alpha: a)
//    }
}
