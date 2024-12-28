// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

public final class HomeService: NetworkManager {
    typealias Endpoint = HomeEndpoint
    
    // Provider 설정
    let provider: MoyaProvider<HomeEndpoint>
    
    public init(provider: MoyaProvider<HomeEndpoint>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = [
            CookiePlugin(),
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)) // 로그 플러그인
        ]
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<HomeEndpoint>(plugins: plugins)
    }
    
    //MARK: - API func
    
    /// 홈 정보 조회
    public func fetchHomeInfo(completion: @escaping (Result<HomeResponseDTO, NetworkError>) -> Void) {
        request(target: .getHomeInfo, decodingType: HomeResponseDTO.self, completion: completion)
    }
}
