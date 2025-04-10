// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import StoreKit
import CoreModule
import Network

enum AppInfoSection: CaseIterable {
    case service
    case privacy
    case location
    case openSource
    case copyright
    case review

    var title: String {
        switch self {
        case .service: return "서비스 이용약관"
        case .privacy: return "개인정보 처리방침"
        case .location: return "위치정보 이용약관"
        case .openSource: return "오픈소스 라이브러리"
        case .copyright: return "저작권 법적 고지"
        case .review: return "개발자 응원하기"
        }
    }

    var content: String? {
        switch self {
        case .service: return Constants.Policy.service
        case .privacy: return Constants.Policy.privacy
        case .location: return Constants.Policy.location
        case .openSource: return Constants.Policy.openSource
        case .copyright: return Constants.Policy.copyright
        case .review: return nil
        }
    }

    var isActionOnly: Bool {
        return self == .review
    }
}
