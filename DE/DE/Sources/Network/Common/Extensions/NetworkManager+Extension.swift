// Copyright © 2024 DRINKIG. All rights reserved

import Moya
import UIKit
import FirebaseAnalytics

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
        
        if let httpResponse = response.response {
            let cookieStorage = CookieStorage()
            cookieStorage.extractTokensAndStore(from: httpResponse) // 🔄 변경된 함수 사용
        }
        
        let decodedResponse = try JSONDecoder().decode(ApiResponse<T>.self, from: response.data)
        guard let result = decodedResponse.result else {
            throw NetworkError.decodingError(devMessage: "[데이터 변환 실패] DTO 양식 확인 필요", userMessage: "데이터 변환에 실패했습니다.\n관리자에게 문의하세요.")
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
        
        if let httpResponse = response.response {
            let cookieStorage = CookieStorage()
            cookieStorage.extractTokensAndStore(from: httpResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(ApiResponse<T>.self, from: response.data)
        guard let result = decodedResponse.result else {
            throw NetworkError.decodingError(devMessage: "[데이터 변환 실패] DTO 양식 확인 필요", userMessage: "데이터 변환에 실패했습니다.\n관리자에게 문의하세요.")
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
            
            let devMessage = errorResponse.message
            let serverErrorCode = ServerErrorCode(rawValue: errorResponse.code) ?? .unknown
            let userMessage = serverErrorCode.errorMessage
            
            print("재시도 횟수 : \(retryCount)")
            // 개발팀 용 로그
            Analytics.logEvent("DRINKIG_NETWORK_ERROR", parameters: [
                "isSuccess" : errorResponse.isSuccess,
                "statusCode": response.statusCode,
                "httpStatusCode" : errorResponse.httpStatus,
                "serverCode": errorResponse.code,
                "message": devMessage
            ])
            
            // 🔄 [토큰 만료] ACCESS_TOKEN4001 또는 ACCESS_TOKEN4002 → 토큰 재발급 후 API 재시도
            if serverErrorCode == .accessTokenExpired || serverErrorCode == .accessTokenInvalid {
                guard retryCount > 0 else {
                    let addDevMessage = "❌ [재시도 한도 초과] API 요청 중단" + devMessage
                    throw NetworkError.tokenExpiredError(statusCode: response.statusCode, devMessage: addDevMessage, userMessage: userMessage)
                }
                print("남은 요청 횟수 : \(retryCount)")
                
                do {
                    _ = try await AuthService().reissueTokenAsync()
                    // ✅ 토큰 재발급 후 동일 API 요청 재시도
                    return try await handleResponseRequired(response, decodingType: decodingType, target: target, retryCount: retryCount - 1)
                } catch {
                    let addDevMessage = "❌ 토큰 재발급 실패 " + devMessage
                    throw NetworkError.tokenExpiredError(statusCode: response.statusCode, devMessage: addDevMessage, userMessage: userMessage)
                }
            }

            if serverErrorCode == .refreshTokenExpired {
                throw NetworkError.refreshTokenExpiredError(statusCode: response.statusCode, devMessage: devMessage, userMessage: userMessage)
            }
            
            throw NetworkError.serverError(statusCode: response.statusCode, devMessage: devMessage, userMessage: userMessage)
            
        } catch {
            if let jsonString = String(data: response.data, encoding: .utf8) {
                print("📜 Raw Response Data: \(jsonString)")
            } else {
                print("❌ 데이터 변환 실패")
            }
            
            throw NetworkError.serverError(statusCode: response.statusCode, devMessage: "서버 응답 해석 실패", userMessage: "서버 응답이 올바르지 않습니다.")
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
            
            let devMessage = errorResponse.message
            let serverErrorCode = ServerErrorCode(rawValue: errorResponse.code) ?? .unknown
            let userMessage = serverErrorCode.errorMessage
            
            print("재시도 횟수 : \(retryCount)")
            // 개발팀 용 로그
            Analytics.logEvent("DRINKIG_NETWORK_ERROR", parameters: [
                "isSuccess" : errorResponse.isSuccess,
                "statusCode": response.statusCode,
                "httpStatusCode" : errorResponse.httpStatus,
                "serverCode": errorResponse.code,
                "message": devMessage
            ])
            
            // 🔄 [토큰 만료] ACCESS_TOKEN4001 또는 ACCESS_TOKEN4002 → 토큰 재발급 후 API 재시도
            if serverErrorCode == .accessTokenExpired || serverErrorCode == .accessTokenInvalid {
                guard retryCount > 0 else {
                    let addDevMessage = "❌ [재시도 한도 초과] API 요청 중단" + devMessage
                    throw NetworkError.tokenExpiredError(statusCode: response.statusCode, devMessage: addDevMessage, userMessage: userMessage)
                }

                do {
                    _ = try await AuthService().reissueTokenAsync()
                    // ✅ 토큰 재발급 후 동일 API 요청 재시도
                    return try await handleResponseRequired(response, decodingType: decodingType, target: target, retryCount: retryCount - 1)
                } catch {
                    let addDevMessage = "❌ 토큰 재발급 실패" + devMessage
                    throw NetworkError.tokenExpiredError(statusCode: response.statusCode, devMessage: addDevMessage, userMessage: userMessage)
                }
            }

            if serverErrorCode == .refreshTokenExpired {
                throw NetworkError.refreshTokenExpiredError(statusCode: response.statusCode, devMessage: devMessage, userMessage: userMessage)
            }
            
            throw NetworkError.serverError(statusCode: response.statusCode, devMessage: devMessage, userMessage: userMessage)
        } catch {
            throw NetworkError.serverError(statusCode: response.statusCode, devMessage: "서버 응답 해석 실패", userMessage: "서버 응답이 올바르지 않습니다.")
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
}
