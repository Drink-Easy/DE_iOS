// Copyright © 2025 DRINKIG. All rights reserved

import Foundation

public protocol VintageSelectionViewModel {
    // 화면 상단에 표시될 제목 (e.g., 와인 이름)
    var screenTitle: String { get }
    
    // 화면 상단에 표시될 설명
    var screenDescription: String { get }
    
    // 사용자가 선택한 빈티지를 저장하는 함수
    func save(vintage: Int)
    
    // '뒤로가기' 시 필요한 데이터 리셋 로직
    func handleBackButton()
}
