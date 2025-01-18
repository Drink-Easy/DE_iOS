// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

public struct WineColor {
    public let colorName: String
    public let colorHexCode: String
    
    /// `WineColor` 초기화 메서드
    /// - Parameters:
    ///   - colorName: 색상 이름
    ///   - colorHexCode: 색상 Hex 코드
    public init(colorName: String, colorHexCode: String) {
        self.colorName = colorName
        self.colorHexCode = colorHexCode
    }
}
