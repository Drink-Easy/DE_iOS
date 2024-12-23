// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

final class TastingNoteService: NetworkManager {
    typealias Endpoint = TastingNoteEndpoint
    
    let provider : MoyaProvider<TastingNoteEndpoint>
    
    init(provider: MoyaProvider<TastingNoteEndpoint>? = nil) {
        // 플러그인 추가
        let plugins: [PluginType] = [
            CookiePlugin(),
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose)) // 로그 플러그인
        ]
        
        // provider 초기화
        self.provider = provider ?? MoyaProvider<TastingNoteEndpoint>(plugins: plugins)
    }
    
    //MARK: - API funcs
    
    // 새 노트 작성
    func postNote(data: TastingNoteRequestDTO, completion: @escaping (Result<String, NetworkError>) -> Void) {
        request(target: .postNote(data: data), decodingType: String.self, completion: completion)
    }
    
    // 노트 수정
    func patchNote(data: TastingNotePatchRequestDTO, completion: @escaping (Result<String, NetworkError>) -> Void) {
        request(target: .patchNote(data: data), decodingType: String.self, completion: completion)
    }
    
    // 노트 삭제
    func deleteNote(noteId: Int, completion: @escaping (Result<String, NetworkError>) -> Void) {
        request(target: .deleteNote(noteId: noteId), decodingType: String.self, completion: completion)
    }
    
    // 특정 노트 정보 조회
    func fetchNote(noteId: Int, completion: @escaping (Result<TastingNoteResponsesDTO, NetworkError>) -> Void) {
        request(target: .getNote(noteId: noteId), decodingType: TastingNoteResponsesDTO.self, completion: completion)
    }
    
    // 모든 노트 정보 조회
    func fetchAllNotes(sort: String, completion: @escaping (Result<AllTastingNoteResponseDTO, NetworkError>) -> Void) {
        request(target: .getAllNotes(sort: sort), decodingType: AllTastingNoteResponseDTO.self, completion: completion)
    }
    
}
