// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

public final class WineService: NetworkManager {
    typealias Endpoint = WineEndpoint

    // Provider 설정
    let provider: MoyaProvider<WineEndpoint>

    public init(provider: MoyaProvider<WineEndpoint>? = nil) {
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
    public func fetchWines(searchName: String, completion: @escaping (Result<[SearchWineResponseDTO], NetworkError>) -> Void) {
        request(target: .getWines(searchName: searchName), decodingType: [SearchWineResponseDTO].self, completion: completion)
    }

    /// 선택 와인 정보 조회
    public func fetchWineInfo(wineId: Int, completion: @escaping (Result<WineResponseWithThreeReviewsDTO?, NetworkError>) -> Void) {
        requestOptional(target: .getWineInfo(wineId: wineId), decodingType: WineResponseWithThreeReviewsDTO.self, completion: completion)
    }
    
    /// 선택 와인 리뷰 조회
    public func fetchWineReviews(wineId: Int, orderByLatest: Bool, completion: @escaping (Result<[WineReviewResponseDTO]?, NetworkError>) -> Void) {
        requestOptional(target: .getWineReview(wineId: wineId, orderByLatest: orderByLatest), decodingType: [WineReviewResponseDTO].self, completion: completion)
    }
    
    /// 추천 와인 조회
    public func fetchRecommendWines(completion: @escaping (Result<([HomeWineDTO], TimeInterval?), NetworkError>) -> Void) {
        requestWithTime(target: .getRecommendWines, decodingType: [HomeWineDTO].self, completion: completion)
//        request(target: .getRecommendWines, decodingType: [HomeWineDTO].self, completion: completion)
    }
    
    /// 인기 와인 조회
    public func fetchPopularWines(completion: @escaping (Result<([HomeWineDTO], TimeInterval?), NetworkError>) -> Void) {
        requestWithTime(target: .getMostLikedWines, decodingType: [HomeWineDTO].self, completion: completion)
//        request(target: .getMostLikedWines, decodingType: [HomeWineDTO].self, completion: completion)
    }
    
}
