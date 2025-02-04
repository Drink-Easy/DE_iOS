// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public class CookieStorage {
    public func extractTokensAndStore(from headers: [AnyHashable: Any]) {
        guard let setCookieHeaders = headers["Set-Cookie"] as? [String] else {
            print("⚠️ `Set-Cookie` 헤더 없음")
            return
        }
        
        var extractedAccessToken: String?
        var extractedRefreshToken: String?
        var accessTokenExpiry: Date?
        var refreshTokenExpiry: Date?
        var path: String = "/" // 기본값
        var isSecure: Bool = true
        var isHttpOnly: Bool = true
        var sameSite: String = "Strict" // 기본값
        
        for cookieString in setCookieHeaders {
            let cookieComponents = cookieString.components(separatedBy: ";").map { $0.trimmingCharacters(in: .whitespaces) }
            
            for component in cookieComponents {
                if component.starts(with: "accessToken=") {
                    extractedAccessToken = component.replacingOccurrences(of: "accessToken=", with: "")
                } else if component.starts(with: "refreshToken=") {
                    extractedRefreshToken = component.replacingOccurrences(of: "refreshToken=", with: "")
                } else if component.starts(with: "Expires=") {
                    if let expiryDate = convertExpiresStringToDate(component.replacingOccurrences(of: "Expires=", with: "")) {
                        if extractedAccessToken != nil {
                            accessTokenExpiry = expiryDate
                        } else if extractedRefreshToken != nil {
                            refreshTokenExpiry = expiryDate
                        }
                    }
                } else if component.starts(with: "Max-Age=") {
                    if let maxAgeSeconds = Double(component.replacingOccurrences(of: "Max-Age=", with: "")) {
                        let expiryDate = Date().addingTimeInterval(maxAgeSeconds)
                        if extractedAccessToken != nil {
                            accessTokenExpiry = expiryDate
                        } else if extractedRefreshToken != nil {
                            refreshTokenExpiry = expiryDate
                        }
                    }
                } else if component.starts(with: "Path=") {
                    path = component.replacingOccurrences(of: "Path=", with: "")
                } else if component.starts(with: "Secure") {
                    isSecure = true
                } else if component.starts(with: "HttpOnly") {
                    isHttpOnly = true
                } else if component.starts(with: "SameSite=") {
                    sameSite = component.replacingOccurrences(of: "SameSite=", with: "")
                }
            }
        }
        
        let finalDomain = API.baseURL
        
        if let accessToken = extractedAccessToken {
            let expiry = accessTokenExpiry ?? Date().addingTimeInterval(86400) // 기본 만료 기간: 24시간
            updateHTTPCookies(with: accessToken, key: "accessToken", expiredIn: expiry, domain: finalDomain, path: path, isSecure: isSecure, isHttpOnly: isHttpOnly, sameSite: sameSite)
        } else {
            print("⚠️ AccessToken을 찾을 수 없음")
        }

        if let refreshToken = extractedRefreshToken {
            let expiry = refreshTokenExpiry ?? Date().addingTimeInterval(86400) // 기본 만료 기간: 24시간
            updateHTTPCookies(with: refreshToken, key: "refreshToken", expiredIn: expiry, domain: finalDomain, path: path, isSecure: isSecure, isHttpOnly: isHttpOnly, sameSite: sameSite)
        } else {
            print("⚠️ RefreshToken을 찾을 수 없음")
        }
    }
    
    private func updateHTTPCookies(with newToken: String, key: String, expiredIn endTime: Date, domain: String, path: String, isSecure: Bool, isHttpOnly: Bool, sameSite: String) {
        guard let url = URL(string: API.baseURL) else { return }

        let newCookie = HTTPCookie(properties: [
            .domain: domain,
            .path: path,
            .name: key,
            .value: newToken,
            .secure: isSecure ? "TRUE" : "FALSE",
            .expires: endTime,
            .sameSitePolicy: sameSite
        ])

        if let newCookie = newCookie {
            HTTPCookieStorage.shared.setCookie(newCookie)
            print("새 토큰 쿠키 생성 성공 : \(key)")
        } else {
            print("⚠️ 새로운 쿠키 생성 실패")
        }

        // ✅ 저장된 쿠키 확인 (디버깅용)
        if let updatedCookies = HTTPCookieStorage.shared.cookies(for: URL(string: API.baseURL)!) {
            print("🍪 현재 저장된 쿠키 목록:")
            for cookie in updatedCookies {
                print("🔹 \(cookie.name): \(cookie.value) | Expiry: \(cookie.expiresDate ?? Date()) | Domain: \(cookie.domain) | Path: \(cookie.path)")
            }
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
