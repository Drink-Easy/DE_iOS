// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Network
import CoreModule

public class NetworkErrorHandler {
    
    /// ✅ 네트워크 에러 핸들링 (🔥 DI로 주입할 클래스)
    public func handleNetworkError(_ error: Error, in viewController: UIViewController) {
        switch error {
        case NetworkError.tokenExpiredError(_, _, let userMessage),
             NetworkError.refreshTokenExpiredError(_, _, let userMessage):
            handleTokenExpirationError(userMessage, in: viewController)
            
        case NetworkError.serverError(_, _, let userMessage),
             NetworkError.decodingError(_, let userMessage),
             NetworkError.networkError(_, let userMessage):
            showToastMessage(message: userMessage, in: viewController)
            
        default:
            showToastMessage(message: "알 수 없는 오류가 발생하였습니다.", in: viewController)
        }
    }
    
    /// ✅ 인증 만료 에러 처리 (로그인 화면 이동)
    private func handleTokenExpirationError(_ userMessage: String, in viewController: UIViewController) {
        let action = UIAlertAction(title: "로그인 하러가기", style: .default) { _ in
            self.redirectToScreen(to: SelectLoginTypeVC(), in: viewController)
        }
        presentAlertView("인증 만료", message: userMessage, alertActions: action, in: viewController)
    }
    
    /// ✅ 특정 화면으로 이동 (예: 로그인 화면)
    private func redirectToScreen(to targetVC: UIViewController, in viewController: UIViewController) {
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                let rootVC = UINavigationController(rootViewController: targetVC)
                window.rootViewController = rootVC
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
            }
        }
    }
    
    /// ✅ 토스트 메시지 표시
    private func showToastMessage(message: String, in viewController: UIViewController) {
        let toastView = ToasterToastMessageView()
        toastView.setupDataBind(message: message)
        
        toastView.center = CGPoint(x: viewController.view.center.x, y: viewController.view.center.y)
        viewController.view.addSubview(toastView)
        
        UIView.animate(withDuration: 0.7, delay: 1.3, options: [.curveEaseIn], animations: {
            toastView.alpha = 0.0
        }) { _ in
            toastView.removeFromSuperview()
        }
    }
    
    /// ✅ 얼럿뷰 띄우기 - 네트워크 에러 처리용
    private func presentAlertView(_ title: String, message: String, alertActions: UIAlertAction, in viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(alertActions)
        viewController.present(alert, animated: true, completion: nil)
    }
}
