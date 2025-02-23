// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

public final class NoticeService: NetworkManager {
    typealias Endpoint = NoticeEndpoint
    
    // Provider 설정
    let provider: MoyaProvider<NoticeEndpoint>
    
    public init(provider: MoyaProvider<NoticeEndpoint>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = [
            CookiePlugin(),
//            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)) // 로그 플러그인
        ]
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<NoticeEndpoint>(plugins: plugins)
    }
    
    //MARK: - API funcs
    
    /// 모든 공지사항 조회
    public func fetchAllNotices() async throws -> [NoticeResponse] {
        return try await requestAsync(target: .getAllNotices, decodingType: [NoticeResponse].self)
    }
    
    /// 단일 공지사항 조회
    public func fetchNotice(id : Int) async throws -> NoticeResponse {
        return try await requestAsync(target: .getNotice(id: id), decodingType: NoticeResponse.self)
    }
    
    /// 홈 배너 조회
    public func fetchHomeBanner() async throws -> BannerResponseList {
        return try await requestAsync(target: .getBanner, decodingType: BannerResponseList.self)
    }
}
