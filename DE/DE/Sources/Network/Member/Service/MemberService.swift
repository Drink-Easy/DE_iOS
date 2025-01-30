// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Moya

public final class MemberService : NetworkManager {
    typealias Endpoint = MemberEndpoint
    
    // MARK: - Provider 설정
    let provider: MoyaProvider<MemberEndpoint>
    
    public init(provider: MoyaProvider<MemberEndpoint>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = [
            CookiePlugin(),
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)) // 로그 플러그인
        ]
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<MemberEndpoint>(plugins: plugins)
    }
    
    // MARK: - DTO funcs
    /// 취향찾기 데이터 생성 함수 - body argument
    public func makeMemberInfoRequestDTO(name: String, isNewbie: Bool, monthPrice: Int, wineSort: [String], wineArea: [String], wineVariety: [String], region: String) -> MemberRequestDTO {
        return MemberRequestDTO(name: name, isNewbie: isNewbie, monthPrice: monthPrice, wineSort: wineSort, wineArea: wineArea, wineVariety: wineVariety, region: region)
    }
    
    /// 프로필 업데이트 데이터 생성 함수 - body argument
    public func makeMemberInfoUpdateRequestDTO(username: String?, city: String?) -> MemberUpdateRequest {
        return MemberUpdateRequest(username: username, city: city)
    }
    
    /// 애플 로그인한 유저 탈퇴 데이터 생성 함수
    public func makeDeleteAppleUserRequest(AuthCode: String) -> AppleDeleteRequest {
        return AppleDeleteRequest(authorizationCode: AuthCode)
    }
    
    /// 닉네임 체크 API
    public func checkNickname(name: String, completion: @escaping (Result<Bool, NetworkError>) -> Void) {
        request(target: .checkNickname(nickname: name), decodingType: Bool.self, completion: completion)
    }
    
    /// 이미지 업로드 API
    public func postImg(image: UIImage, completion: @escaping (Result<String, NetworkError>) -> Void) {
        request(target: .postImage(image: image), decodingType: String.self, completion: completion)
    }
    
    public func postImgAsync(image: UIImage) async throws -> String {
        return try await requestAsync(target: .postImage(image: image), decodingType: String.self)
    }
    
    /// 개인정보 갱신 API(마이페이지)
    public func patchUserInfo(body: MemberUpdateRequest, completion: @escaping (Result<String, NetworkError>) -> Void) {
        request(target: .patchMemeberPersonalInfo(body: body), decodingType: String.self, completion: completion)
    }
    
    public func patchUserInfoAsync(body: MemberUpdateRequest) async throws -> String {
        return try await requestAsync(target: .patchMemeberPersonalInfo(body: body), decodingType: String.self)
    }
    
    /// 취향찾기 등록 API
    public func postUserInfo(body: MemberRequestDTO, completion: @escaping (Result<String, NetworkError>) -> Void) {
        request(target: .patchMemberInfo(body: body), decodingType: String.self, completion: completion)
    }
    
    public func postUserInfoAsync(body: MemberRequestDTO) async throws -> String {
        return try await requestAsync(target: .patchMemberInfo(body: body))
    }
    
    /// 개인정보 불러오기 API
    public func fetchUserInfo(completion: @escaping (Result<MemberInfoResponse, NetworkError>) -> Void) {
        request(target: .getMemberInfo, decodingType: MemberInfoResponse.self, completion: completion)
    }
    
    public func getUserName() async throws -> String {
        return try await requestAsync(target: .getNickname)
    }
    
    /// 사용자 탈퇴 API
    public func deleteUser(completion: @escaping (Result<String, NetworkError>) -> Void) {
        request(target: .deleteMember, decodingType: String.self, completion: completion)
    }
    
    public func deleteAppleUser(body: AppleDeleteRequest) async throws -> String {
        try await requestAsync(target: .deleteAppleUser(body: body))
    }
    
}
