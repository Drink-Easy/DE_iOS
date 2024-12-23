// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

final class RecommentService: NetworkManager {
    typealias Endpoint = RecommentEndpoints
    
    // Provider 설정
    let provider: MoyaProvider<RecommentEndpoints>
    
    init(provider: MoyaProvider<RecommentEndpoints>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = [
            CookiePlugin(),
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)) // 로그 플러그인
        ]
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<RecommentEndpoints>(plugins: plugins)
    }
    
    /// 대댓글 등록 데이터 생성
    func makePostDTO(commentId: Int, content: String) -> RecommentRequestDTO {
        return RecommentRequestDTO(commentId: commentId, content: content)
    }
    
    //MARK: - API funcs
    
    /// 대댓글 작성
    func postComment(data: RecommentRequestDTO, completion: @escaping (Result<String, NetworkError>) -> Void) {
        request(target: .postRecomments(requestDTO: data), decodingType: String.self, completion: completion)
    }
    
    /// 대댓글 삭제
    func deleteComment(recommentId: Int, completion: @escaping (Result<String, NetworkError>) -> Void) {
        request(target: .deleteRecomments(recommentId: recommentId), decodingType: String.self, completion: completion)
    }
    
}
