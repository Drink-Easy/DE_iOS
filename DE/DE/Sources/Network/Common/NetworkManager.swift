// Copyright © 2024 DRINKIG. All rights reserved

import Moya
import Foundation

protocol NetworkManager {
    associatedtype Endpoint: TargetType
    
    var provider: MoyaProvider<Endpoint> { get }
    
    func request<T: Decodable>(
        target: Endpoint,
        decodingType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}

extension NetworkManager {
    func request<T: Decodable>(
        target: Endpoint,
        decodingType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    // 상태 코드 검사
                    guard (200...299).contains(response.statusCode) else {
                        let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: response.data)
                        completion(.failure(.serverError(message: errorResponse?.message ?? "Unknown server error")))
                        return
                    }
                    // JSON 디코딩
                    let apiResponse = try JSONDecoder().decode(ApiResponse<T>.self, from: response.data)
                    completion(.success(apiResponse.result))
                } catch {
                    completion(.failure(.decodingError))
                }
            case .failure:
                completion(.failure(.networkError))
            }
        }
    }
    
    func requestStatusCode(
        target: Endpoint,
        completion: @escaping (Result<Void, NetworkError>) -> Void
    ) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    completion(.success(()))
                } else {
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: response.data)
                    completion(.failure(.serverError(message: errorResponse?.message ?? "Unknown server error")))
                }
            case .failure:
                completion(.failure(.networkError))
            }
        }
    }
}
