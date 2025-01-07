// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
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
    
    public func checkNickname(name: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
        request(target: .checkNickname(nickname: name), decodingType: String.self, completion: completion)
    }
    
}
