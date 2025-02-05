// Copyright © 2024 DRINKIG. All rights reserved

import Moya
import Foundation

protocol NetworkManager {
    associatedtype Endpoint: TargetType
    var provider: MoyaProvider<Endpoint> { get }
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
