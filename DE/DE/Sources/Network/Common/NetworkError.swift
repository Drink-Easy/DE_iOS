// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

enum NetworkError: Error {
    case networkError(message: String)
    case decodingError
    case serverError(statusCode: Int, message: String)
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "네트워크 오류: \(message)"
        case .decodingError:
            return "데이터 디코딩에 실패했습니다."
        case .serverError(let statusCode, let message):
            return "[오류 \(statusCode)] \(message)"
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}


struct ErrorResponse: Decodable {
    let message: String
}
