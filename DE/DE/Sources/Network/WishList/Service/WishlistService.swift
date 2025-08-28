// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

public final class WishlistService: NetworkManager {
    typealias Endpoint = WishlistEndpoint
    
    // Provider 설정
    let provider: MoyaProvider<WishlistEndpoint>
    
    public init(provider: MoyaProvider<WishlistEndpoint>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = {
            var p: [PluginType] = [CookiePlugin()]
#if DEBUG
            p.append(NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))) // 로그 플러그인
#endif
            return p
        }()
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<WishlistEndpoint>(plugins: plugins)
    }
    
    //MARK: - API funcs
    
    /// 위시리스트 조회 API
    public func fetchWishlist() async throws-> [WinePreviewResponse]?{
        return try await requestOptionalAsync(
            target: .getWishList,
            decodingType: [WinePreviewResponse].self
        )
    }
    
    /// 위시리스트 등록 API
    /// - Parameter wineId: 위시리스트에 추가할 와인의 ID
    /// - Throws: NetworkError
    /// - Returns: 성공 메시지 (`String`)
    public func postWishlist(wineId: Int, vintageYear: Int? = nil) async throws -> String {
        return try await requestAsync(
            target: .postWishList(wineId: wineId, vintageYear: vintageYear)
        )
    }

    /// 위시리스트 삭제 API
    /// - Parameter wineId: 위시리스트에서 삭제할 와인의 ID
    /// - Throws: NetworkError
    /// - Returns: 성공 메시지 (`String`)
    public func deleteWishlist(wineId: Int, vintageYear: Int? = nil) async throws -> String {
        return try await requestAsync(
            target: .deleteWineLike(wineId: wineId, vintageYear: vintageYear)
        )
    }
}
