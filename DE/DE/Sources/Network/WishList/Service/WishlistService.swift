// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

public final class WishlistService: NetworkManager {
    typealias Endpoint = WishlistEndpoint
    
    // Provider 설정
    let provider: MoyaProvider<WishlistEndpoint>
    
    public init(provider: MoyaProvider<WishlistEndpoint>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = [
            CookiePlugin(),
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)) // 로그 플러그인
        ]
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<WishlistEndpoint>(plugins: plugins)
    }
    
    //MARK: - API funcs
    
    /// 위시리스트 조회 API
    public func fetchWishlist(completion: @escaping (Result<[WineWishlistResponseDTO], NetworkError>) -> Void) {
        request(target: .getWishList, decodingType: [WineWishlistResponseDTO].self, completion: completion)
    }
    
    /// 위시리스트 등록 API
    public func postWishlist(wineId: Int, completion: @escaping (Result<WineWishlistResponseDTO, NetworkError>) -> Void) {
        request(target: .postWishList(wineId: wineId), decodingType: WineWishlistResponseDTO.self, completion: completion)
    }
    
    /// 위시리스트 삭제 API
    public func deleteWishlist(wineWishlistId: Int, completion: @escaping (Result<String, NetworkError>) -> Void) {
        request(target: .deleteWineLike(wineWishlistId: wineWishlistId), decodingType: String.self, completion: completion)
    }
}

