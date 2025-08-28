// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

public final class MyWineService : NetworkManager {
    typealias Endpoint = MyWineEndpoint
    
    // MARK: - Provider 설정
    let provider: MoyaProvider<MyWineEndpoint>
    
    public init(provider: MoyaProvider<MyWineEndpoint>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = {
            var p: [PluginType] = [CookiePlugin()]
#if DEBUG
            p.append(NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))) // 로그 플러그인
#endif
            return p
        }()
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<MyWineEndpoint>(plugins: plugins)
    }
    
    // MARK: - DTO funcs
    
    /// 보유와인 추가 데이터 구조 생성
    public func makePostDTO(wineId: Int, buyDate: String, buyPrice: Int) -> MyWineRequest {
        return MyWineRequest(wineId: wineId, purchaseDate: buyDate, purchasePrice: buyPrice)
    }
    
    /// 보유와인 업데이트 데이터 구조 생성
    public func makeUpdateDTO(buyDate: String? = nil, buyPrice: Int? = nil) -> MyWineUpdateRequest {
        return MyWineUpdateRequest(purchaseDate: buyDate, purchasePrice: buyPrice)
    }
    
    /// 보유와인 가져오기 API
    public func fetchAllMyWines() async throws -> [MyWineResponse]? {
        return try await requestOptionalAsync(
            target: .getMyWines,
            decodingType: [MyWineResponse].self
        )
    }
    
    /// 하나의 보유와인 가져오기 API
    public func fetchMyWine(myWineId: Int) async throws -> MyWineResponse {
        return try await requestAsync(
            target: .getOneMyWine(myWineId: myWineId),
            decodingType: MyWineResponse.self
        )
    }
    
    /// 새 보유와인 등록하기 API
    public func postMyWine(data: MyWineRequest) async throws -> String {
        return try await requestAsync(target: .postMyWine(data: data))
    }
    
    /// 보유와인 정보 업데이트 API
    public func updateMyWine(myWineId: Int, data: MyWineUpdateRequest) async throws -> String {
        return try await requestAsync(
            target: .patchMyWine(myWineId: myWineId, data: data)
        )
    }
    
    /// 보유와인 삭제하기 API
    public func deleteMyWine(myWineId: Int) async throws -> String {
        return try await requestAsync(target: .deleteMyWine(myWineId: myWineId))
    }
}
