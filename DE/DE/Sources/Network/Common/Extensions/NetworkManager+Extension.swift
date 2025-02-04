// Copyright © 2024 DRINKIG. All rights reserved

import Moya
import UIKit

extension NetworkManager {
    //MARK: - Concurrency로 모두 리팩토링
    // ✅ 1. 비동기 데이터 요청
    func requestAsync<T: Decodable>(
        target: Endpoint,
        decodingType: T.Type = String.self
    ) async throws -> T {
        let response = try await provider.request(target)
        return try await handleResponseRequired(response, decodingType: decodingType, target: target)
    }

    // ✅ 2. 옵셔널 응답 (데이터가 없을 수도 있음)
    func requestOptionalAsync<T: Decodable>(
        target: Endpoint,
        decodingType: T.Type = String.self
    ) async throws -> T? {
        let response = try await provider.request(target)
        
        // 서버 응답이 비어있는 경우 nil 반환
        if response.data.isEmpty { return nil }
        
        return try await handleResponseOptional(response, decodingType: decodingType, target: target)
    }
    
    // ✅ 3. 응답 + 캐시 유효 시간 반환
    func requestWithTimeAsync<T: Decodable>(
        target: Endpoint,
        decodingType: T.Type = String.self
    ) async throws -> (T, TimeInterval?) {
        let response = try await provider.request(target)
        let result = try await handleResponseRequired(response, decodingType: decodingType, target: target)
        
        let cacheTime = extractCacheTimeInterval(from: response)
        return (result, cacheTime)
    }
    
    // MARK: - 상태 코드 처리 처리 함수
    // ✅ 공통 응답 처리 함수
    private func handleResponseRequired<T: Decodable>(
        _ response: Response,
        decodingType: T.Type,
        target: Endpoint,
        retryCount: Int = 1
    ) async throws -> T {
        guard (200...299).contains(response.statusCode) else {
            return try await handleErrorResponseRequired(response, target: target, decodingType: decodingType)
        }
        
        if let headers = response.response?.allHeaderFields {
            extractTokensAndStore(from: headers)
        }
        
        let decodedResponse = try JSONDecoder().decode(ApiResponse<T>.self, from: response.data)
        guard let result = decodedResponse.result else {
            throw NetworkError.decodingError
        }

        return result
    }
    
    private func handleResponseOptional<T: Decodable>(
        _ response: Response,
        decodingType: T.Type,
        target: Endpoint,
        retryCount: Int = 1
    ) async throws -> T? {
        guard (200...299).contains(response.statusCode) else {
            return try await handleErrorResponseOptional(response, target: target, decodingType: decodingType)
        }
        
        if let headers = response.response?.allHeaderFields {
            extractTokensAndStore(from: headers)
        }
        
        let decodedResponse = try JSONDecoder().decode(ApiResponse<T>.self, from: response.data)
        guard let result = decodedResponse.result else {
            throw NetworkError.decodingError
        }

        return result
    }
    
    private func handleErrorResponseRequired<T: Decodable>(
        _ response: Response,
        target: Endpoint,
        decodingType: T.Type,
        retryCount: Int = 1 // ✅ 재시도 횟수 제한 추가
    ) async throws -> T {
        do {
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
            
            if errorResponse.code == "ACCESS_TOKEN4002" {
                print("🔄 [토큰 만료] 토큰 재발급 시작...")

                guard retryCount > 0 else {
                    print("❌ [재시도 한도 초과] API 요청 중단")
                    throw NetworkError.tokenExpiredError
                }

                do {
                    _ = try await AuthService().reissueTokenAsync()
                    print("✅ [토큰 재발급 완료] API 재요청 실행...")

                    // ✅ 토큰이 재발급되었으므로 동일 API 요청 다시 실행 (재시도 횟수 감소)
                    return try await handleResponseRequired(response, decodingType: decodingType, target: target, retryCount: retryCount - 1)
                } catch {
                    print("❌ [토큰 재발급 실패] \(error.localizedDescription)")
                    throw NetworkError.tokenExpiredError
                }
            } else if errorResponse.code == "ACCESS_TOKEN4001" {
                throw NetworkError.tokenExpiredError
            }
            
            throw NetworkError.serverError(statusCode: response.statusCode, message: errorResponse.message)
        } catch {
            throw NetworkError.serverError(statusCode: response.statusCode, message: "서버 응답 해석 실패")
        }
    }
    
    private func handleErrorResponseOptional<T: Decodable>(
        _ response: Response,
        target: Endpoint,
        decodingType: T.Type,
        retryCount: Int = 1 // ✅ 재시도 횟수 제한 추가
    ) async throws -> T? {
        do {
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
            
            if errorResponse.code == "ACCESS_TOKEN4002" {
                print("🔄 [토큰 만료] 토큰 재발급 시작...")

                guard retryCount > 0 else {
                    print("❌ [재시도 한도 초과] API 요청 중단")
                    throw NetworkError.tokenExpiredError
                }

                do {
                    _ = try await AuthService().reissueTokenAsync()
                    print("✅ [토큰 재발급 완료] API 재요청 실행...")

                    return try await handleResponseOptional(response, decodingType: decodingType, target: target, retryCount: retryCount - 1)
                } catch {
                    print("❌ [토큰 재발급 실패] \(error.localizedDescription)")
                    throw NetworkError.tokenExpiredError
                }
            } else if errorResponse.code == "ACCESS_TOKEN4001" {
                throw NetworkError.tokenExpiredError
            }
            
            throw NetworkError.serverError(statusCode: response.statusCode, message: errorResponse.message)
        } catch {
            throw NetworkError.serverError(statusCode: response.statusCode, message: "서버 응답 해석 실패")
        }
    }
    
    func extractCacheTimeInterval(from response: Response) -> TimeInterval? {
        guard let httpResponse = response.response,
              let cacheControl = httpResponse.allHeaderFields["Cache-Control"] as? String else {
            print("⚠️ Cache-Control 헤더가 없습니다.")
            return nil
        }

        let components = cacheControl.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        for component in components {
            if component.starts(with: "max-age") {
                let maxAgeValue = component.split(separator: "=").last
                if let maxAgeString = maxAgeValue, let maxAge = TimeInterval(maxAgeString) {
                    return maxAge
                }
            }
        }
        
        print("⚠️ Cache-Control 헤더에서 max-age를 찾을 수 없습니다.")
        return nil
    }
    
    /// ✅ 토큰 관련 에러를 검증하고, 필요하면 재발급 요청 -> Concurrency
    private func checkTokenErrorAndReissueAsync(
        response: Response
    ) async throws -> Bool { // ✅ 성공 여부 반환
        do {
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data)

            if errorResponse.code == "ACCESS_TOKEN4002" {
                print("🔄 [토큰 만료] 토큰 재발급 시작...")

                // ✅ 토큰 재발급 요청 (자동 저장됨)
                let response = try await AuthService().reissueTokenAsync()

                return true // 🔄 토큰 재발급 성공
            }
        } catch {
            print("⚠️ [에러 응답 디코딩 실패] \(error.localizedDescription)")
            throw error
        }
        
        return false // ❌ 토큰 만료와 무관한 오류
    }
    
    private func extractTokensAndStore(from headers: [AnyHashable: Any]) {
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
        guard let url = URL(string: "https://\(domain)") else { return }

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
        } else {
            print("⚠️ 새로운 쿠키 생성 실패")
        }

        // ✅ 저장된 쿠키 확인 (디버깅용)
        if let updatedCookies = HTTPCookieStorage.shared.cookies {
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
