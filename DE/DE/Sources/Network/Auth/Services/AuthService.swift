// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

final class AuthService {
    private let provider : MoyaProvider<AuthorizationEndpoints>
    
    init(provider: MoyaProvider<AuthorizationEndpoints> = MoyaProvider<AuthorizationEndpoints>()) {
        self.provider = provider
    }
    
    // MARK: - 공통 요청 메서드
    private func request<T: Decodable>(
        target: AuthorizationEndpoints,
        decodingType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    guard (200...299).contains(response.statusCode) else {
                        let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: response.data)
                        completion(.failure(.serverError(message: errorResponse?.message ?? "Unknown server error")))
                        return
                    }
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
    
    // MARK: - API 호출 메서드
    func login(data: LoginDTO, completion: @escaping (Result<LoginResponseDTO, NetworkError>) -> Void) {
        request(target: .postLogin(data: data), decodingType: LoginResponseDTO.self, completion: completion)
    }
    
    func logout(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        provider.request(.postLogout) { result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    completion(.success(()))
                } else {
                    completion(.failure(.serverError(message: "Logout failed.")))
                }
            case .failure:
                completion(.failure(.networkError))
            }
        }
    }
    
    func join(data: JoinDTO, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        provider.request(.postJoin(data: data)) { result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    completion(.success(()))
                } else {
                    completion(.failure(.serverError(message: "Join failed.")))
                }
            case .failure:
                completion(.failure(.networkError))
            }
        }
    }
    
    func reissueToken(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        provider.request(.postReIssueToken) { result in
            switch result {
            case .success(let response):
                if (200...299).contains(response.statusCode) {
                    completion(.success(()))
                } else {
                    completion(.failure(.serverError(message: "Token reissue failed.")))
                }
            case .failure:
                completion(.failure(.networkError))
            }
        }
    }
}
