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
