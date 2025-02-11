// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import UIKit

public class TextFilter {
    var bannedWords: [String] = []
    let lineSplitRegex = "\\r\\n|\\n\\r|\\n|\\r"
    
    public init(filePath: String) {
        if let content = try? String(contentsOfFile: filePath, encoding: .utf8) {
            self.bannedWords = content.components(separatedBy: CharacterSet.newlines)
        }
    }
    
    public func checkFWords(_ textString: String) -> Bool {
        let lowercasedText = textString.lowercased() // 입력된 문자열을 소문자로 변환
        
        for word in bannedWords {
            if lowercasedText.contains(word.lowercased()) { // 단어 리스트도 소문자로 변환 후 비교
                return true
            }
        }
        return false
    }
}
