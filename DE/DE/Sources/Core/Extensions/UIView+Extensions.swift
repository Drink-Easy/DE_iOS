// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

extension UIView {
    public func showBlockingView() {
        let blockingView = UIView(frame: self.bounds)
        blockingView.backgroundColor = .clear
        blockingView.tag = 999  // 태그를 지정하여 쉽게 제거 가능
        self.addSubview(blockingView)
        indicator.startAnimating()
    }
    
    public func hideBlockingView() {
        self.viewWithTag(999)?.removeFromSuperview()
        indicator.stopAnimating()
    }
}
