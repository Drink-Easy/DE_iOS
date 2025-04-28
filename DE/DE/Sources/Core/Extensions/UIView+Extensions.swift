// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import DesignSystem

extension UIView {
    public func showBlockingView() {
        if let viewController = self.findViewController() {
            viewController.navigationItem.rightBarButtonItem?.isEnabled = false // ✅ 오른쪽 버튼 비활성화
            viewController.navigationItem.leftBarButtonItem?.isEnabled = false  // ✅ 왼쪽 버튼 비활성화
        }
        
        if let navigationController = self.findNavigationController() {
            navigationController.view.isUserInteractionEnabled = false // ✅ 전체 뷰 터치 차단
        }
        //인디케이터 시작, 투명 뷰
        let blockingView = UIView(frame: self.bounds)
        blockingView.backgroundColor = .clear
        blockingView.tag = 999  // 태그를 지정하여 쉽게 제거 가능
        self.addSubview(blockingView)
        indicator.startAnimating()
    }
    
    public func showColorBlockingView() {
        if let viewController = self.findViewController() {
            viewController.navigationItem.rightBarButtonItem?.isEnabled = false
            viewController.navigationItem.leftBarButtonItem?.isEnabled = false
        }
        
        if let navigationController = self.findNavigationController() {
            navigationController.view.isUserInteractionEnabled = false
        }
        //인디케이터 시작, 배경색 뷰로 뷰컨 데이터 안 보이게
        let blockingView = UIView(frame: self.bounds)
        blockingView.backgroundColor = AppColor.background
        blockingView.tag = 999  // 태그를 지정하여 쉽게 제거 가능
        self.addSubview(blockingView)
        indicator.startAnimating()
    }
    
    public func hideBlockingView() {
        if let viewController = self.findViewController() {
            viewController.navigationItem.rightBarButtonItem?.isEnabled = true // ✅ 버튼 다시 활성화
            viewController.navigationItem.leftBarButtonItem?.isEnabled = true
        }
        
        if let navigationController = self.findNavigationController() {
            navigationController.view.isUserInteractionEnabled = true
        }
        
        self.viewWithTag(999)?.removeFromSuperview()
        indicator.stopAnimating()
    }
    
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
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
    
    /// 여러 개의 서브뷰를 한 번에 추가하는 함수
    public func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
