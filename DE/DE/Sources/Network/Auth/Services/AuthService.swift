// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

public final class AuthService : NetworkManager {
    typealias Endpoint = AuthorizationEndpoints
    
    // MARK: - Provider 설정
    let provider: MoyaProvider<AuthorizationEndpoints>
    
    public init(provider: MoyaProvider<AuthorizationEndpoints>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = [
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)) // 로그 플러그인
        ]
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<AuthorizationEndpoints>(plugins: plugins)
    }
    
    // MARK: - DTO funcs
    
    /// 로그인 데이터 구조 생성
    public func makeLoginDTO(username: String, password: String) -> LoginDTO {
        return LoginDTO(username: username, password: password)
    }
    
    /// 자체 회원가입 데이터 구조 생성
    public func makeJoinDTO(username: String, password: String, rePassword: String) -> JoinDTO {
        return JoinDTO(username: username, password: password, rePassword: rePassword)
    }
    
    /// 카카오 로그인 데이터 구조 생성
    public func makeKakaoDTO(username: String, email: String) -> KakaoLoginRequestDTO {
        return KakaoLoginRequestDTO(kakaoName: username, kakaoEmail: email)
    }
    
    /// 애플 로그인 데이터 구조 생성
    public func makeAppleDTO(idToken: String) -> AppleLoginRequestDTO {
        return AppleLoginRequestDTO(identityToken: idToken)
    }
    
    /// 이메일 중복 체크 데이터 구조 생성
    public func makeEmailCheckDTO(emailString: String) -> UsernameCheckRequest {
        return UsernameCheckRequest(username: emailString)
    }
    
    /// 유저 정보 데이터 구조 생성
//    public func makeUserInfoDTO(name: String, isNewBie: Bool, monthPrice: Int, wineSort: [String], wineArea: [String], region: String) -> MemberRequestDTO {
//        return MemberRequestDTO(name: name, isNewBie: isNewBie, monthPrice: monthPrice, wineSort: wineSort, wineArea: wineArea, region: region)
//    }

    //MARK: - API funcs
    /// 자체 로그인 API
    public func login(data: LoginDTO, completion: @escaping (Result<LoginResponseDTO, NetworkError>) -> Void) {
        request(target: .postLogin(data: data), decodingType: LoginResponseDTO.self, completion: completion)
    }
    
    /// 카카오 로그인 API
    public func kakaoLogin(data: KakaoLoginRequestDTO, completion: @escaping (Result<LoginResponseDTO, NetworkError>) -> Void) {
        request(target: .postKakaoLogin(data: data), decodingType: LoginResponseDTO.self, completion: completion)
    }
    
    /// 애플 로그인 API
    public func appleLogin(data: AppleLoginRequestDTO, completion: @escaping (Result<LoginResponseDTO, NetworkError>) -> Void) {
        request(target: .postAppleLogin(data: data), decodingType: LoginResponseDTO.self, completion: completion)
    }
    
    /// 로그아웃 API
    public func logout(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        provider.request(.postLogout) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    completion(.success(()))
                } else {
                    let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: response.data)
                    let finalMessage = errorResponse?.message ?? "에러 메세지 없음"
                    return completion(.failure(.serverError(statusCode: response.statusCode, message: finalMessage)))
                }
                
            case .failure(let error):
                let networkError = self.handleNetworkError(error)
                completion(.failure(networkError))
            }
        }
    }
    
    /// 자체 회원가입 API
    public func join(data: JoinDTO, completion: @escaping (Result<String, NetworkError>) -> Void) {
        request(target: .postJoin(data: data), decodingType: String.self, completion: completion)
    }
    
    /// 이메일 중복 체크 API
    public func checkEmail(data : UsernameCheckRequest, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        request(target: .emailVerification(data: data), decodingType: Bool.self, completion: completion)
    }
    
    /// 토큰 재발급 API
    public func reissueToken(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        requestStatusCode(target: .postReIssueToken, completion: completion)
    }
    
    /// 멤버 정보 전송 API
//    public func sendMemberInfo(data: MemberRequestDTO, completion: @escaping (Result<MemberResponseDTO, NetworkError>) -> Void) {
//        request(target: .patchMemberInfo(data: data), decodingType: MemberResponseDTO.self, completion: completion)
//    }
}
