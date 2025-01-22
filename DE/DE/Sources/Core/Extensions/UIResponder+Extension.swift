// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

extension UIResponder {

    public struct Static {
        static weak var responder: UIResponder?
    }

    // 현재 응답자 반환하는 computed property
    public static var currentResponder: UIResponder? {
        // Static.responder 초기화
        Static.responder = nil
        // 특정 동작을 유발시켜서 현재 응답자를 찾아내는 방식
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        // 찾아낸 UIResponder 반환
        return Static.responder
    }

    // 현재 응답자 저장하는 private 메서드
    @objc public func _trap() {
        Static.responder = self
    }
}
