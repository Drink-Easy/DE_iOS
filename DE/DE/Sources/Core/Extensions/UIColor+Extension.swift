// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

public struct AppColor {
    
    //        static public let purple100 = UIColor(hex: "#7E13B1")
    //        static public let purple70 = UIColor(hex: "#9741BF")
    //        static public let purple50 = UIColor(hex: "#B06FCD")
    //        static public let purple30 = UIColor(hex: "#D5B3E2")
            static public let purple20 = UIColor(hex: "#E1CAE9")
    //        static public let purple10 = UIColor(hex: "#EEE1F0")
    //
    static public let grayBG = UIColor(hex: "F8F8FA")
    static public let DGblack = AppColor.black
    //        static public let gray100 = UIColor(hex: "#434343")
    //        static public let gray90 = UIColor(hex: "#5D5D5D")
    static public let gray80 = UIColor(hex: "#A7A7A7")
    //        static public let gray70 = UIColor(hex: "#7A7A7A")
    static public let gray60 = UIColor(hex: "#DADADA")
    //        static public let gray50 = UIColor(hex: "#ABABAB")
    static public let gray40 = UIColor(hex: "#E9E9E9")
    //        static public let gray30 = UIColor(hex: "#D7D7D7")
    static public let gray20 = UIColor(hex: "#F8F8F8")
    //        static public let gray10 = UIColor(hex: "#EAEAEA")
    //
    //        static public let red = UIColor(hex: "FF6F6F")
    
    static public let purple100 = UIColor(named: "purple100")
    static public let purple70 = UIColor(named: "purple70")
    static public let purple50 = UIColor(named: "purple50")
    static public let purple30 = UIColor(named: "purple30")
    static public let purple10 = UIColor(named: "purple10")
    
    static public let gray100 = UIColor(named: "gray100")
    static public let gray90 = UIColor(named: "gray90")
    static public let gray70 = UIColor(named: "gray70")
    static public let gray50 = UIColor(named: "gray50")
    static public let gray30 = UIColor(named: "gray30")
    static public let gray10 = UIColor(named: "gray10")
    
    static public let black = UIColor(named: "Dblack")
    static public let white = UIColor(named: "Dwhite")
    static public let bgGray = UIColor(named: "background")
    static public let red = UIColor(named: "red")
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
    
    func toHex() -> String? {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            let rgb: Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
            return String(format: "#%06x", rgb)
        }
        return nil
    }
}
