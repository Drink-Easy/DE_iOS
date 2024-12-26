// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

final class CookiePlugin: PluginType {
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        
        // 저장된 쿠키를 가져와서 헤더에 추가
        if let cookies = HTTPCookieStorage.shared.cookies {
            let cookieHeader = HTTPCookie.requestHeaderFields(with: cookies)
            for (key, value) in cookieHeader {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        return request
    }
    
//    func fetchTokens() {
//        if let url = URL(string: "https://drinkeg.com/login") {
//            if let cookies = HTTPCookieStorage.shared.cookies(for: url) {
//                for cookie in cookies {
//                    print("쿠키 이름 : \(cookie.name), 값 : \(cookie.value)")
//                    print("")
//                }
//            }
//        }
//    }
}
