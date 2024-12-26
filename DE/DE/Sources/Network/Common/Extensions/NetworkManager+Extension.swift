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
                // ✅ 빈 데이터를 처리하는 ApiResponse 타입으로 요청
                let result: Result<ApiResponse<String?>, NetworkError> = handleResponse(
                    response,
                    decodingType: ApiResponse<String?>.self
                )
                
                switch result {
                case .success:
                    completion(.success(())) // 성공 처리
                case .failure(let error):
                    completion(.failure(error)) // 실패 처리
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
            // 1. 상태 코드 확인
            guard (200...299).contains(response.statusCode) else {
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

            // 2. 응답 디코딩
            let apiResponse = try JSONDecoder().decode(ApiResponse<T>.self, from: response.data)

            // ✅ result가 없는 경우 처리 (옵셔널 대응)
            if let result = apiResponse.result {
                return .success(result)
            } else if T.self == String?.self { // 빈 데이터일 경우 허용
                return .success("" as! T)
            } else {
                return .failure(.serverError(statusCode: response.statusCode, message: "결과 데이터가 없습니다."))
            }

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
