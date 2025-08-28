// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

public final class AuthService : NetworkManager {
    typealias Endpoint = AuthorizationEndpoints
    
    // MARK: - Provider 설정
    let provider: MoyaProvider<AuthorizationEndpoints>
    
    public init(provider: MoyaProvider<AuthorizationEndpoints>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = {
            var p: [PluginType] = []
#if DEBUG
            p.append(NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))) // 로그 플러그인
#endif
            return p
        }()
        
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
    public func login(data: LoginDTO) async throws -> LoginResponseDTO {
        return try await requestAsync(target: .postLogin(data: data), decodingType: LoginResponseDTO.self)
    }
    
    /// 카카오 로그인 API
    public func kakaoLogin(data: KakaoLoginRequestDTO) async throws -> LoginResponseDTO {
        return try await requestAsync(target: .postKakaoLogin(data: data), decodingType: LoginResponseDTO.self)
    }
    
    /// 애플 로그인 API
    public func appleLogin(data: AppleLoginRequestDTO) async throws -> LoginResponseDTO {
        return try await requestAsync(target: .postAppleLogin(data: data), decodingType: LoginResponseDTO.self)
    }
    /// 로그아웃 API
    public func logout() async throws -> String {
        return try await requestAsync(target: .postLogout, decodingType: String.self)
    }
    
    /// 자체 회원가입 API
    public func join(data: JoinDTO) async throws -> String {
        return try await requestAsync(target: .postJoin(data: data), decodingType: String.self)
    }
    /// 이메일 중복 체크 API
    public func checkEmail(data: UsernameCheckRequest) async throws -> Bool {
        return try await requestAsync(target: .emailVerification(data: data), decodingType: Bool.self)
    }
    /// ✅ 토큰 재발급 API (무한 루프 방지)
    private static var isReissuingToken = false

    public func reissueTokenAsync() async throws {
        guard !AuthService.isReissuingToken else {
            throw NetworkError.serverError(statusCode: 401, devMessage: "이미 토큰 재발급 요청 중", userMessage: "이미 토큰 재발급 요청 중")
        }
        
        AuthService.isReissuingToken = true // ✅ 재발급 진행 중
        defer { AuthService.isReissuingToken = false } // ✅ 요청 완료 후 해제
        
        let response = try await provider.request(.postReIssueToken)
        
        guard (200...299).contains(response.statusCode) else {
            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
            let serverErrorCode = ServerErrorCode(rawValue: errorResponse.code) ?? .unknown
            let userMessage = serverErrorCode.errorMessage
            let devMessage = errorResponse.message
            
            throw NetworkError.refreshTokenExpiredError(statusCode: response.statusCode, devMessage: devMessage, userMessage: userMessage)
        }
        
        if let httpResponse = response.response {
            let cookieStorage = CookieStorage()
            cookieStorage.extractTokensAndStore(from: httpResponse)
        }
    }
}
