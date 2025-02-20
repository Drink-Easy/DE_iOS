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
    public func makeMemberInfoRequestDTO(name: String, isNewbie: Bool, monthPrice: Int, wineSort: [String], wineArea: [String], wineVariety: [String]) -> MemberRequestDTO {
        return MemberRequestDTO(name: name, isNewbie: isNewbie, monthPrice: monthPrice, wineSort: wineSort, wineArea: wineArea, wineVariety: wineVariety)
    }
    
    /// 프로필 업데이트 데이터 생성 함수 - body argument
    public func makeMemberInfoUpdateRequestDTO(username: String?) -> MemberUpdateRequest {
        return MemberUpdateRequest(username: username)
    }
    
    /// 애플 로그인한 유저 탈퇴 데이터 생성 함수
    public func makeDeleteAppleUserRequest(AuthCode: String) -> AppleDeleteRequest {
        return AppleDeleteRequest(authorizationCode: AuthCode)
    }
    
    /// 닉네임 체크 API
    public func checkNickname(name: String) async throws -> Bool {
        return try await requestAsync(target: .checkNickname(nickname: name), decodingType: Bool.self)
    }
    
    /// 이미지 업로드 API
    public func postImgAsync(image: UIImage) async throws -> String {
        return try await requestAsync(target: .postImage(image: image), decodingType: String.self)
    }
    
    /// 개인정보 갱신 API(마이페이지)
    public func patchUserInfoAsync(body: MemberUpdateRequest) async throws -> String {
        return try await requestAsync(target: .patchMemeberPersonalInfo(body: body), decodingType: String.self)
    }
    
    /// 취향찾기 등록 API
    public func postUserInfoAsync(body: MemberRequestDTO) async throws -> String {
        return try await requestAsync(target: .patchMemberInfo(body: body), decodingType: String.self)
    }
    
    /// 개인정보 불러오기 API
    public func fetchUserInfoAsync() async throws -> MemberInfoResponse {
        return try await requestAsync(target: .getMemberInfo, decodingType: MemberInfoResponse.self)
    }
    
    public func getUserName() async throws -> String {
        return try await requestAsync(target: .getNickname, decodingType: String.self)
    }
    
    /// 사용자 탈퇴 API
    public func deleteUser() async throws -> String {
        return try await requestAsync(target: .deleteMember, decodingType: String.self)
    }
    
    public func deleteAppleUser(body: AppleDeleteRequest) async throws -> String {
        return try await requestAsync(target: .deleteAppleUser(body: body))
    }
    
    /// 사용자 프로필 이미지 삭제하기
    public func deleteProfileImage() async throws -> String {
        return try await requestAsync(target: .deleteImage)
    }
    
}
