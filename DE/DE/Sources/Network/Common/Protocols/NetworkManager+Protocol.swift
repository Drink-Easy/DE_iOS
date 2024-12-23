// Copyright © 2024 DRINKIG. All rights reserved

import Moya
import Foundation

protocol NetworkManager {
    associatedtype Endpoint: TargetType
    
    var provider: MoyaProvider<Endpoint> { get }
    
    func request<T: Decodable>(
        target: Endpoint,
        decodingType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}
