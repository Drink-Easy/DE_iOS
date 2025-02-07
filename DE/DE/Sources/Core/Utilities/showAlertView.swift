// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit

extension UIViewController {
    /// 커스텀 얼럿 뷰를 현재 뷰 컨트롤러에 추가하는 함수
    public func showAlertView(title: String, message: String) {
        let alertView = CustomAlertView()
        alertView.configure(title: title, message: message) // ✅ 매개변수 전달

        self.view.addSubview(alertView) // ✅ 현재 뷰 컨트롤러의 view에 추가
        self.view.bringSubviewToFront(alertView) // ✅ 최상위에 배치

        alertView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
