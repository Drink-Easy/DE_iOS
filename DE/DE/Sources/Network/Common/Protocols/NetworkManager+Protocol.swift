// Copyright © 2024 DRINKIG. All rights reserved

import Moya
import Foundation

protocol NetworkManager {
    associatedtype Endpoint: TargetType
    
    var provider: MoyaProvider<Endpoint> { get }
    
    // ✅ 1. 일반 데이터 요청 (T, 필수값)
    func request<T: Decodable>(
        target: Endpoint,
        decodingType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
    
    // ✅ 2. 일반 데이터 요청 (T?, 옵셔널)
    func requestOptional<T: Decodable>(
        target: Endpoint,
        decodingType: T.Type,
        completion: @escaping (Result<T?, NetworkError>) -> Void
    )
    
    // ✅ 캐시 유효 시간 포함
    func requestWithTime<T: Decodable>(
        target: Endpoint,
        decodingType: T.Type,
        completion: @escaping (Result<(T, TimeInterval?), NetworkError>) -> Void
    )
    
    // Concurrency 코드
    func requestAsync<T: Decodable>(
        target: Endpoint,
        decodingType: T.Type
    ) async throws -> T
    
    func requestOptionalAsync<T: Decodable>(
        target: Endpoint,
        decodingType: T.Type
    ) async throws -> T?
    
    func requestWithTime<T: Decodable>(
        target: Endpoint,
        decodingType: T.Type
    ) async throws -> (T?, TimeInterval)
    
}

extension MoyaProvider {
    func request(_ target: Target) async throws -> Response {
        return try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
