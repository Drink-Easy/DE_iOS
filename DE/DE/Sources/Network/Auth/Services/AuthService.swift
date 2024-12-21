// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

final class AuthService : NetworkManager {
    typealias Endpoint = AuthorizationEndpoints
    
    //MARK: - Provider 설정
    let provider: MoyaProvider<AuthorizationEndpoints>
    
    init(provider: MoyaProvider<AuthorizationEndpoints> = MoyaProvider<AuthorizationEndpoints>()) {
        self.provider = provider
    }

    //MARK: - API funcs
    func login(data: LoginDTO, completion: @escaping (Result<LoginResponseDTO, NetworkError>) -> Void) {
        request(target: .postLogin(data: data), decodingType: LoginResponseDTO.self, completion: completion)
    }
    
    func logout(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        requestStatusCode(target: .postLogout, completion: completion)
    }
    
    func join(data: JoinDTO, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        request(target: .postJoin(data: data), decodingType: EmptyResponse.self) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func reissueToken(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        request(target: .postReIssueToken, decodingType: EmptyResponse.self) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
