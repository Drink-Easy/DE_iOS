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
    public func fetchWines(searchName: String, page: Int) async throws -> PageSearchWineResponseDTO? {
        return try await requestOptionalAsync(
            target: .getWines(
                searchName: searchName,
                page: page
            ),
            decodingType: PageSearchWineResponseDTO.self
        )
    }

    /// 선택 와인 정보 조회
    public func fetchWineInfo(wineId: Int, vintageYear: Int?) async throws -> WineResponseWithThreeReviewsDTO? {
        return try await requestOptionalAsync(
            target: .getWineInfo(wineId: wineId, vintageYear: vintageYear),
            decodingType: WineResponseWithThreeReviewsDTO.self
        )
    }
    
    /// 선택 와인 리뷰 조회
    public func fetchWineReviews(wineId: Int, vintageYear: Int?, sortType: String, page: Int) async throws -> PageResponseWineReviewResponse? {
        return try await requestAsync(
            target: .getWineReview(wineId: wineId, vintageYear: vintageYear, sortType: sortType, page: page),
            decodingType: PageResponseWineReviewResponse.self
        )
    }
    
    /// 추천 와인 조회
    public func fetchRecommendWines() async throws -> ([HomeWineDTO], TimeInterval?) {
        return try await requestWithTimeAsync(
            target: .getRecommendWines,
            decodingType: [HomeWineDTO].self
        )
    }
    
    /// 인기 와인 조회
    public func fetchPopularWines() async throws -> ([HomeWineDTO], TimeInterval?) {
        return try await requestWithTimeAsync(
            target: .getMostLikedWines,
            decodingType: [HomeWineDTO].self
        )
    }
    
}
