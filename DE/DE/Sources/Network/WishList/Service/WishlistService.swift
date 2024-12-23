// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

final class WishlistService: NetworkManager {
    typealias Endpoint = WishlistEndpoint
    
    // Provider 설정
    let provider: MoyaProvider<WishlistEndpoint>
    
    init(provider: MoyaProvider<WishlistEndpoint>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = [
            CookiePlugin(),
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)) // 로그 플러그인
        ]
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<WishlistEndpoint>(plugins: plugins)
    }
    
    /// 위시리스트 등록 데이터 생성
    func makePostDTO(wineId: Int) -> WineWishlistRequestDTO {
        return WineWishlistRequestDTO(wineId: wineId)
    }
    
    //MARK: - API funcs
    
    /// 위시리스트 조회
    func fetchWishlist(completion: @escaping (Result<[WineWishlistResponseDTO], NetworkError>) -> Void) {
        request(target: .getWishList, decodingType: [WineWishlistResponseDTO].self, completion: completion)
    }
    
    /// 위시리스트 등록
    func postWishlist(data: WineWishlistRequestDTO, completion: @escaping (Result<WineWishlistResponseDTO, NetworkError>) -> Void) {
        request(target: .postWishList(data: data), decodingType: WineWishlistResponseDTO.self, completion: completion)
    }
    
    /// 위시리스트 삭제
    func deleteWishlist(wineWishlistId: Int, completion: @escaping (Result<String, NetworkError>) -> Void) {
        request(target: .deleteWineLike(wineWishlistId: wineWishlistId), decodingType: String.self, completion: completion)
    }
}

