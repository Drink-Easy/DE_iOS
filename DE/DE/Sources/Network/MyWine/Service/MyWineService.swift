// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

public final class MyWineService : NetworkManager {
    typealias Endpoint = MyWineEndpoint
    
    // MARK: - Provider 설정
    let provider: MoyaProvider<MyWineEndpoint>
    
    public init(provider: MoyaProvider<MyWineEndpoint>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = [
            CookiePlugin(),
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)) // 로그 플러그인
        ]
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<MyWineEndpoint>(plugins: plugins)
    }
    
    // MARK: - DTO funcs
    
    /// 보유와인 추가 데이터 구조 생성
    public func makePostDTO(wineId: Int, buyDate: String, buyPrice: Int) -> MyWineRequest {
        return MyWineRequest(wineId: wineId, purchaseData: buyDate, purchasePrice: buyPrice)
    }
    
    /// 보유와인 업데이트 데이터 구조 생성
    public func makeUpdateDTO(buyDate: String?, buyPrice: Int?) -> MyWineUpdateRequest {
        return MyWineUpdateRequest(purchaseData: buyDate, purchasePrice: buyPrice)
    }
    
    /// 보유와인 가져오기
    public func fetchAllMyWines(completion: @escaping (Result<[MyWineResponse]?, NetworkError>) -> Void) {
        requestOptional(target: .getMyWines, decodingType: [MyWineResponse].self, completion: completion)
    }
    
    /// 새 보유와인 등록하기
    public func postMyWine(data: MyWineRequest, completion: @escaping (Result<String, NetworkError>) -> Void) {
        request(target: .postMyWine(data: data), decodingType: String.self, completion: completion)
    }
    
    public func updateMyWine(myWineId: Int, data: MyWineUpdateRequest, completion: @escaping (Result<String, NetworkError>) -> Void) {
        request(target: .patchMyWine(wineId: myWineId, data: data), decodingType: String.self, completion: completion)
    }
}
