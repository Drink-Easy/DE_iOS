// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

public final class WineColorManager {
    /// 와인 색상 리스트
    public let colors: [WineColor] = [
        WineColor(colorName: "레몬 크림", colorHexCode: "F2EBC0", isLight: true),
        WineColor(colorName: "샴페인 골드", colorHexCode: "FDEFA4", isLight: true),
        WineColor(colorName: "스위트 콘", colorHexCode: "F8C34F", isLight: true),
        WineColor(colorName: "허니 골드", colorHexCode: "DDA736", isLight: true),
        WineColor(colorName: "멜론", colorHexCode: "FEB6B6", isLight: true),
        WineColor(colorName: "로즈 캐러멜", colorHexCode: "BA7B39", isLight: true),
        
        WineColor(colorName: "다크 코코아", colorHexCode: "89271A", isLight: false),
        WineColor(colorName: "체리 레드", colorHexCode: "6C0C16", isLight: false),
        WineColor(colorName: "루비 와인", colorHexCode: "A7253B", isLight: false),
        WineColor(colorName: "칠리 페퍼 레드", colorHexCode: "BA2121", isLight: false),
        WineColor(colorName: "초콜릿 브라운", colorHexCode: "5C1D37", isLight: false),
        WineColor(colorName: "캐러멜 브라운", colorHexCode: "2A1416", isLight: false)
        ]
    
    /// 컬러 이름으로 Hex 코드를 반환하는 함수
    ///
    /// - Parameter colorName: 검색하려는 색상의 이름
    /// - Returns: 해당 색상의 Hex 코드 (문자열) 또는 `nil` (색상을 찾지 못한 경우)
    func getHexCode(for colorName: String) -> String? {
        // 색상 이름과 일치하는 Hex 코드를 검색
        return colors.first { $0.colorName == colorName }?.colorHexCode
    }
    
    /// Hex 코드로 컬러 이름을 반환하는 함수
    ///
    /// - Parameter hexCode: 검색하려는 색상의 Hex 코드
    /// - Returns: 해당 색상의 이름 (문자열) 또는 `nil` (Hex 코드를 찾지 못한 경우)
    func getColorName(for hexCode: String) -> String? {
        // Hex 코드와 일치하는 색상 이름을 검색
        return colors.first { $0.colorHexCode == hexCode }?.colorName
    }
}
