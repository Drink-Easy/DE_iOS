// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

final class AuthService : NetworkManager {
    typealias Endpoint = AuthorizationEndpoints
    
    //MARK: - Provider 설정
    let provider: MoyaProvider<AuthorizationEndpoints>
    
    init(provider: MoyaProvider<AuthorizationEndpoints>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = [
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)) // 로그 플러그인
        ]
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<AuthorizationEndpoints>(plugins: plugins)
    }
    
    //MARK: - DTO funcs
    
    /// 로그인 데이터 구조 생성
    func makeLoginDTO(username: String, password: String) -> LoginDTO {
        return LoginDTO(username: username, password: password)
    }
    
    /// 자체 회원가입 데이터 구조 생성
    func makeJoinDTO(username: String, password: String, rePassword: String) -> JoinDTO {
        return JoinDTO(username: username, password: password, rePassword: rePassword)
    }

    //MARK: - API funcs
    /// 자체 로그인
    func login(data: LoginDTO, completion: @escaping (Result<LoginResponseDTO, NetworkError>) -> Void) {
        request(target: .postLogin(data: data), decodingType: LoginResponseDTO.self, completion: completion)
    }
    
    /// 로그아웃
    func logout(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        requestStatusCode(target: .postLogout, completion: completion)
    }
    
    /// 자체 회원가입
    func join(data: JoinDTO, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        requestStatusCode(target: .postJoin(data: data), completion: completion)
    }
    
    /// 토큰 재발급
    func reissueToken(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        requestStatusCode(target: .postReIssueToken, completion: completion)
    }
}
