// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public class CookieStorage {
    public func extractTokensAndStore(from response: HTTPURLResponse) {
        guard let setCookieHeader = response.allHeaderFields["Set-Cookie"] as? String else {
            return
        }

        var extractedAccessToken: String?
        var extractedRefreshToken: String?
        var accessTokenExpiry: Date?
        var refreshTokenExpiry: Date?

        let cookies = setCookieHeader.components(separatedBy: ", ")
        
        var currentTokenType: String? // 현재 처리 중인 토큰 타입 (accessToken 또는 refreshToken)

        for cookie in cookies {
            let components = cookie.components(separatedBy: ";").map { $0.trimmingCharacters(in: .whitespaces) }

            for component in components {
                if component.starts(with: "accessToken=") {
                    extractedAccessToken = component.replacingOccurrences(of: "accessToken=", with: "")
                    currentTokenType = "accessToken"
                } else if component.starts(with: "refreshToken=") {
                    extractedRefreshToken = component.replacingOccurrences(of: "refreshToken=", with: "")
                    currentTokenType = "refreshToken"
                } else if component.starts(with: "Expires=") {
                    if let expiryDate = convertExpiresStringToDate(component.replacingOccurrences(of: "Expires=", with: "")) {
                        if currentTokenType == "accessToken" {
                            accessTokenExpiry = expiryDate
                        } else if currentTokenType == "refreshToken" {
                            refreshTokenExpiry = expiryDate
                        }
                    }
                } else if component.starts(with: "Max-Age=") {
                    if let maxAgeSeconds = Double(component.replacingOccurrences(of: "Max-Age=", with: "")) {
                        let expiryDate = Date().addingTimeInterval(maxAgeSeconds)
                        if currentTokenType == "accessToken" {
                            accessTokenExpiry = expiryDate
                        } else if currentTokenType == "refreshToken" {
                            refreshTokenExpiry = expiryDate
                        }
                    }
                }
            }
        }

        // ✅ 최종적으로 쿠키 저장
        let domain = API.baseURL

        if let accessToken = extractedAccessToken {
            let expiry = accessTokenExpiry ?? Date().addingTimeInterval(3600)
            updateHTTPCookies(with: accessToken, key: "accessToken", expiredIn: expiry, domain: domain)
        } else {
            print("⚠️ AccessToken을 찾을 수 없음")
        }

        if let refreshToken = extractedRefreshToken {
            let expiry = refreshTokenExpiry ?? Date().addingTimeInterval(864000)
            updateHTTPCookies(with: refreshToken, key: "refreshToken", expiredIn: expiry, domain: domain)
        } else {
            print("⚠️ RefreshToken을 찾을 수 없음")
        }
    }

    /// ✅ 쿠키 저장 함수
    private func updateHTTPCookies(with newToken: String, key: String, expiredIn endTime: Date, domain: String) {
        guard let url = URL(string: domain) else { return }
        
        // 기존 토큰 삭제
        if let existingCookies = HTTPCookieStorage.shared.cookies {
            for cookie in existingCookies {
                if cookie.name == key {
                    HTTPCookieStorage.shared.deleteCookie(cookie)
                }
            }
        }

        let newCookie = HTTPCookie(properties: [
            .domain: url.host!,
            .path: "/",
            .name: key,
            .value: newToken,
            .expires: endTime,
            .secure: "TRUE"
        ])

        if let newCookie = newCookie {
            HTTPCookieStorage.shared.setCookie(newCookie)
//            print("✅ 새로운 \(key) 쿠키 저장 완료: \(newCookie.value)")
        } else {
//            print("⚠️ 새로운 쿠키 생성 실패")
        }
    }

    /// ✅ `Expires="Wed, 05 Feb 2025 17:51:04 GMT"` 형식의 문자열을 `Date`로 변환하는 함수
    private func convertExpiresStringToDate(_ expiresString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        return formatter.date(from: expiresString)
    }
}
