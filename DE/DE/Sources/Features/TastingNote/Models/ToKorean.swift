// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

enum WineSort: String {
    case red = "red"
    case white = "white"
    case sparkling = "sparkling"
    case rose = "rose"
    case etc = "etc"
    
    static func toKorean(_ korean: String) -> WineSort? {
        switch korean {
        case "레드": return .red
        case "화이트": return .white
        case "스파클링": return .sparkling
        case "로제": return .rose
        case "기타": return .etc
        default: return nil
        }
    }
}
