// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

extension UIViewController {
    public func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // 다른 UI 이벤트와 충돌 방지
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // 토스트 메시지를 보여주는 메서드
    public func showToastMessage(message: String) {
        let toastView = ToasterToastMessageView()
        toastView.setupDataBind(message: message)
        
        // 토스트 뷰 중앙 정렬 (화면의 가운데 정렬)
        toastView.center = CGPoint(x: view.center.x,
                                   y: view.frame.height * 0.8) // 화면 아래쪽에 배치
        
        view.addSubview(toastView)
        
        UIView.animate(withDuration: 3.0,
                       delay: 0.0,
                       options: [.curveEaseIn, .beginFromCurrentState],
                       animations: {
            toastView.alpha = 0.0
        }) { _ in
            toastView.removeFromSuperview()
        }
    }
}
