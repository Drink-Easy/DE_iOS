// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

final class CommentService: NetworkManager {
    typealias Endpoint = CommentEndpoints
    
    // Provider 설정
    let provider: MoyaProvider<CommentEndpoints>
    
    init(provider: MoyaProvider<CommentEndpoints> = MoyaProvider<CommentEndpoints>()) {
        self.provider = provider
    }
    
    //MARK: - API funcs
    
    // 댓글 작성
    func postComment(data: CommentRequestDTO, completion: @escaping (Result<String, NetworkError>) -> Void) {
        request(target: .postComments(data: data), decodingType: String.self, completion: completion)
    }
    
    // 댓글 수정
    func patchComment(commentId: Int, completion: @escaping (Result<String, NetworkError>) -> Void) {
        request(target: .patchComments(commentId: commentId), decodingType: String.self, completion: completion)
    }
    
    // 댓글 삭제
    func deleteComment(commentId: Int, completion: @escaping (Result<String, NetworkError>) -> Void) {
        request(target: .deleteComments(commentId: commentId), decodingType: String.self, completion: completion)
    }
    
    // 댓글 목록 조회
    func fetchComments(partyId: Int, completion: @escaping (Result<[CommentResponseDTO], NetworkError>) -> Void) {
        request(target: .getComments(partyId: partyId), decodingType: [CommentResponseDTO].self, completion: completion)
    }
    
    // 댓글 개수 조회
    func fetchCommentsCount(partyId: Int, completion: @escaping (Result<Int, NetworkError>) -> Void) {
        request(target: .getCommentsCount(partyId: partyId), decodingType: Int.self, completion: completion)
    }
    
}
