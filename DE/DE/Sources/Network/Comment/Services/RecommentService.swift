// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

final class RecommentService: NetworkManager {
    typealias Endpoint = RecommentEndpoints
    
    // Provider 설정
    let provider: MoyaProvider<RecommentEndpoints>
    
    init(provider: MoyaProvider<RecommentEndpoints> = MoyaProvider<RecommentEndpoints>()) {
        self.provider = provider
    }
    
    //MARK: - API funcs
    
    // 대댓글 작성
    func postComment(data: RecommentRequestDTO, completion: @escaping (Result<String, NetworkError>) -> Void) {
        request(target: .postRecomments(requestDTO: data), decodingType: String.self, completion: completion)
    }
    
    // 대댓글 삭제
    func deleteComment(recommentId: Int, completion: @escaping (Result<String, NetworkError>) -> Void) {
        request(target: .deleteRecomments(recommentId: recommentId), decodingType: String.self, completion: completion)
    }
    
}
