// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import FirebaseAnalytics

/// 🔥 Firebase 로깅을 위한 프로토콜
public protocol FirebaseTrackable {
    var screenName: String { get }
}

extension FirebaseTrackable where Self: UIViewController {
    /// ✅ 현재 화면의 클래스명을 자동으로 가져옴
    var screenName: String {
        return NSStringFromClass(type(of: self))
    }
    
    /// 🔥 화면 방문 이벤트 자동 로깅 (viewDidAppear에서 호출)
    public func logScreenView(fileName: String) {
        Analytics.logEvent("화면 진입(screen_view)", parameters: [
            "screen_name": screenName,
            "screen_class": screenName,
            "file_name" : fileName
        ])
        print("✅ Firebase Analytics - 화면 방문 기록: \(screenName)")
    }
}

extension FirebaseTrackable {
    /// 🔥 특정 이벤트 로깅
    public func logEvent(_ eventName: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(eventName, parameters: parameters)
    }

    /// 🔥 테이블뷰/콜렉션뷰 셀 클릭 이벤트 로깅
    public func logCellClick(screenName: String, indexPath: IndexPath, cellName: String, fileName: String, cellID: String) {
        Analytics.logEvent("셀 선택(cell_click)", parameters: [
            "screen_name": screenName,
            "cell_name": cellName,
            "section": indexPath.section,
            "row": indexPath.row,
            "file_name" : fileName,
            "cell_ID" : cellID
        ])
    }

    /// 🔥 버튼 클릭 이벤트 로깅
    public func logButtonClick(screenName: String, buttonName: String, fileName: String) {
        Analytics.logEvent("버튼 클릭(button_clicked)", parameters: [
            "screen_name": screenName,
            "button_name": buttonName,
            "file_name" : fileName
        ])
    }
}
