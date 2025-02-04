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
                _ = try await AuthService().reissueTokenAsync()

                return true // 🔄 토큰 재발급 성공
            }
        } catch {
            print("⚠️ [에러 응답 디코딩 실패] \(error.localizedDescription)")
            throw error
        }
        
        return false // ❌ 토큰 만료와 무관한 오류
    }
}
