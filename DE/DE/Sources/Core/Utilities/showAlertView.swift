// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit

extension UIViewController {
    /// 커스텀 얼럿 뷰를 현재 뷰 컨트롤러에 추가하는 함수
    public func showAlertView(message: String) {
        let alertView = CustomAlertView()
        alertView.configure(title: "드링키지 점검 안내", message: "보다 안정적인 서비스 제공을 위해\n아래와 같이 시스템 점검을 진행합니다.\n\n[점검 시간]\n\(message)") // ✅ 매개변수 전달
        self.view.addSubview(alertView) // ✅ 현재 뷰 컨트롤러의 view에 추가
        self.view.bringSubviewToFront(alertView) // ✅ 최상위에 배치
        alertView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    public func showUpdateAlertView() {
        let alertView = CustomAlertView()
        alertView.configure(title: "드링키지 업데이트 안내", message: "더 나은 서비스 이용을 위해\n앱스토어에서 새로운 버전의\n드링키지로 업데이트해 주세요!") // ✅ 매개변수 전달
        self.view.addSubview(alertView) // ✅ 현재 뷰 컨트롤러의 view에 추가
        self.view.bringSubviewToFront(alertView) // ✅ 최상위에 배치

        alertView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
