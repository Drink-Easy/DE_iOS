// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

final class WineService: NetworkManager {
    typealias Endpoint = WineEndpoint
    
    // Provider 설정
    let provider: MoyaProvider<WineEndpoint>
    
    init(provider: MoyaProvider<WineEndpoint>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = [
            CookiePlugin(),
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)) // 로그 플러그인
        ]
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<WineEndpoint>(plugins: plugins)
    }
    
    //MARK: - API funcs
    
    /// 와인 검색
    func fetchWines(searchName: String, completion: @escaping (Result<[SearchWineResponseDTO], NetworkError>) -> Void) {
        request(target: .getWines(searchName: searchName), decodingType: [SearchWineResponseDTO].self, completion: completion)
    }
    
    /// 선택 와인 정보 조회
    func fetchWineInfo(wineId: Int, completion: @escaping (Result<WineResponseWithThreeReviewsDTO, NetworkError>) -> Void) {
        request(target: .getWineInfo(wineId: wineId), decodingType: WineResponseWithThreeReviewsDTO.self, completion: completion)
    }
    
    /// 선택 와인 리뷰 조회
    func fetchWineReviews(wineId: Int, completion: @escaping (Result<[WineReviewResponseDTO], NetworkError>) -> Void) {
        request(target: .getWineReview(wineId: wineId), decodingType: [WineReviewResponseDTO].self, completion: completion)
    }
    
}
