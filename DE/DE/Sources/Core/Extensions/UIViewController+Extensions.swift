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
    public func showToastMessage(message: String, yPosition: CGFloat) {
        let toastView = ToasterToastMessageView()
        toastView.setupDataBind(message: message)
        
        toastView.center = CGPoint(x: view.center.x, y: yPosition)
        
        view.addSubview(toastView)
        
        UIView.animate(withDuration: 0.7, delay: 1.3, options: [.curveEaseIn], animations: {
            toastView.alpha = 0.0
        }) { _ in
            toastView.removeFromSuperview()
        }
    }
}
