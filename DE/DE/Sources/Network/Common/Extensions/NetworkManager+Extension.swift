// Copyright © 2024 DRINKIG. All rights reserved

import Moya
import Foundation

extension NetworkManager {
    func request<T: Decodable>(
        target: Endpoint,
        decodingType: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                let result: Result<T, NetworkError> = handleResponse(response, decodingType: decodingType)
                completion(result)
                
            case .failure(let error):
                let networkError = handleNetworkError(error)
                completion(.failure(networkError))
            }
        }
    }
    
    func requestStatusCode(
        target: Endpoint,
        completion: @escaping (Result<Void, NetworkError>) -> Void
    ) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                let result: Result<ApiResponse<EmptyResponse>, NetworkError> = handleResponse(
                    response,
                    decodingType: ApiResponse<EmptyResponse>.self
                )
                
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
                
            case .failure(let error):
                let networkError = handleNetworkError(error)
                completion(.failure(networkError))
            }
        }
    }
    
    // MARK: - 상태 코드 처리 처리 함수
    private func handleResponse<T: Decodable>(
        _ response: Response,
        decodingType: T.Type
    ) -> Result<T, NetworkError> {
        do {
            guard (200...299).contains(response.statusCode) else {
                // 상태 코드별 기본 메시지 설정
                let errorMessage: String
                switch response.statusCode {
                case 300..<400:
                    errorMessage = "리다이렉션 오류가 발생했습니다. 코드: \(response.statusCode)"
                case 400..<500:
                    errorMessage = "클라이언트 오류가 발생했습니다. 코드: \(response.statusCode)"
                case 500..<600:
                    errorMessage = "서버 오류가 발생했습니다. 코드: \(response.statusCode)"
                default:
                    errorMessage = "알 수 없는 오류가 발생했습니다. 코드: \(response.statusCode)"
                }
                
                // 서버 응답 메시지 디코딩
                let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: response.data)
                let finalMessage = errorResponse?.message ?? errorMessage
                
                return .failure(.serverError(statusCode: response.statusCode, message: finalMessage))
            }
            
            let apiResponse = try JSONDecoder().decode(ApiResponse<T>.self, from: response.data)
            return .success(apiResponse.result)
            
        } catch {
            return .failure(.decodingError)
        }
    }
    
    // MARK: - 네트워크 오류 처리 함수
    private func handleNetworkError(_ error: Error) -> NetworkError {
        let nsError = error as NSError
        switch nsError.code {
        case NSURLErrorNotConnectedToInternet:
            return .networkError(message: "인터넷 연결이 끊겼습니다.")
        case NSURLErrorTimedOut:
            return .networkError(message: "요청 시간이 초과되었습니다.")
        default:
            return .networkError(message: "네트워크 오류가 발생했습니다.")
        }
    }
}
