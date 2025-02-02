// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

extension UIView {
    public func showBlockingView() {
        if let navigationController = self.findNavigationController() {
            navigationController.navigationBar.isUserInteractionEnabled = false
        }
        //인디케이터 시작, 투명 뷰
        let blockingView = UIView(frame: self.bounds)
        blockingView.backgroundColor = .clear
        blockingView.tag = 999  // 태그를 지정하여 쉽게 제거 가능
        self.addSubview(blockingView)
        indicator.startAnimating()
    }
    
    public func showColorBlockingView() {
        if let navigationController = self.findNavigationController() {
            navigationController.navigationBar.isUserInteractionEnabled = false
        }
        //인디케이터 시작, 배경색 뷰로 뷰컨 데이터 안 보이게
        let blockingView = UIView(frame: self.bounds)
        blockingView.backgroundColor = AppColor.bgGray
        blockingView.tag = 999  // 태그를 지정하여 쉽게 제거 가능
        self.addSubview(blockingView)
        indicator.startAnimating()
    }
    
    public func hideBlockingView() {
        if let navigationController = self.findNavigationController() {
            navigationController.navigationBar.isUserInteractionEnabled = true
        }
        
        self.viewWithTag(999)?.removeFromSuperview()
        indicator.stopAnimating()
    }
    
    private func findNavigationController() -> UINavigationController? {
            var responder: UIResponder? = self
            while let nextResponder = responder?.next {
                if let navigationController = nextResponder as? UINavigationController {
                    return navigationController
                }
                responder = nextResponder
            }
            return nil
        }
}
