// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import DesignSystem

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
    
    // 이동하고 싶은 화면, 내비게이션 포함 유무
    public func redirectToScreen(to targetVC: UIViewController, withNavigation: Bool = true) {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                let rootVC = withNavigation ? UINavigationController(rootViewController: targetVC) : targetVC
                
                window.rootViewController = rootVC
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
            }
        }
    }
    
    // 얼럿뷰 띄우기 - 네트워크 에러처리
    public func presentAlertView(_ title : String, message : String, alertActions : UIAlertAction) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        // 얼럿 메뉴 추가
        alert.addAction(alertActions)
        
        present(alert, animated: true, completion: nil)
    }
}
