// Copyright © 2024 DRINKIG. All rights reserved

import Moya
import UIKit
import FirebaseAnalytics

extension NetworkManager {
    // MARK: - 상태 코드 처리 처리 함수
    // ✅ 공통 응답 처리 함수
    func handleResponseRequired<T: Decodable>(
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
            cookieStorage.extractTokensAndStore(from: httpResponse)
        }
        
        let decodedResponse = try JSONDecoder().decode(ApiResponse<T>.self, from: response.data)
        guard let result = decodedResponse.result else {
            throw NetworkError.decodingError(devMessage: "[데이터 변환 실패] DTO 양식 확인 필요", userMessage: "데이터 변환에 실패했습니다.\n관리자에게 문의하세요.")
        }
        
        return result
    }
    
    func handleResponseOptional<T: Decodable>(
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
        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
        
        let devMessage = errorResponse.message
        let serverErrorCode = ServerErrorCode(rawValue: errorResponse.code) ?? .unknown
        let userMessage = serverErrorCode.errorMessage
        
        Analytics.logEvent("DRINKIG_NETWORK_ERROR", parameters: [
            "isSuccess" : errorResponse.isSuccess,
            "statusCode": response.statusCode,
            "httpStatusCode" : errorResponse.httpStatus,
            "serverCode": errorResponse.code,
            "message": devMessage
        ])
        
        if serverErrorCode == .refreshTokenExpired {
            throw NetworkError.refreshTokenExpiredError(statusCode: response.statusCode, devMessage: devMessage, userMessage: userMessage)
        }
        
        // 🔄 [토큰 만료] ACCESS_TOKEN4001 또는 ACCESS_TOKEN4002 → 토큰 재발급 후 API 재시도
        if serverErrorCode == .accessTokenExpired || serverErrorCode == .accessTokenInvalid {
            guard retryCount > 0 else {
                let addDevMessage = "[자동 인증 재시도 한도 초과] " + devMessage
                throw NetworkError.tokenExpiredError(statusCode: response.statusCode, devMessage: addDevMessage, userMessage: userMessage)
            }
            
            do {
                try await AuthService().reissueTokenAsync()
                return try await requestAsync(target: target, decodingType: decodingType)
            } catch {
                let addDevMessage = "[자동 인증 시도 실패]" + devMessage
                throw NetworkError.tokenExpiredError(statusCode: response.statusCode, devMessage: addDevMessage, userMessage: userMessage)
            }
        }
        
        throw NetworkError.serverError(statusCode: response.statusCode, devMessage: devMessage, userMessage: userMessage)
    }
    
    func handleErrorResponseOptional<T: Decodable>(
        _ response: Response,
        target: Endpoint,
        decodingType: T.Type,
        retryCount: Int = 1 // ✅ 재시도 횟수 제한 추가
    ) async throws -> T? {
        let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
        
        let devMessage = errorResponse.message
        let serverErrorCode = ServerErrorCode(rawValue: errorResponse.code) ?? .unknown
        let userMessage = serverErrorCode.errorMessage
        
        Analytics.logEvent("DRINKIG_NETWORK_ERROR", parameters: [
            "isSuccess" : errorResponse.isSuccess,
            "statusCode": response.statusCode,
            "httpStatusCode" : errorResponse.httpStatus,
            "serverCode": errorResponse.code,
            "message": devMessage
        ])
        
        if serverErrorCode == .refreshTokenExpired {
            throw NetworkError.refreshTokenExpiredError(statusCode: response.statusCode, devMessage: devMessage, userMessage: userMessage)
        }

        if serverErrorCode == .accessTokenExpired || serverErrorCode == .accessTokenInvalid {
            guard retryCount > 0 else {
                let addDevMessage = "[자동 인증 재시도 한도 초과] " + devMessage
                throw NetworkError.tokenExpiredError(statusCode: response.statusCode, devMessage: addDevMessage, userMessage: userMessage)
            }
            
            do {
                try await AuthService().reissueTokenAsync() // 토큰 재발급 성공하면,
                return try await requestOptionalAsync(target: target, decodingType: decodingType) // 기존 요청 재시도
            } catch {
                let addDevMessage = "[자동 인증 시도 실패]" + devMessage
                throw NetworkError.tokenExpiredError(statusCode: response.statusCode, devMessage: addDevMessage, userMessage: userMessage)
            }
        }
        
        throw NetworkError.serverError(statusCode: response.statusCode, devMessage: devMessage, userMessage: userMessage)
    }
    
}
