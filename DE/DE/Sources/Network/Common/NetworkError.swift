// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public enum NetworkError: Error {
    case networkError(message: String)
    case decodingError
    case serverError(statusCode: Int, message: String)
    case unknown
    case tokenExpiredError
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return "네트워크 오류: \(message)"
        case .decodingError:
            return "데이터 디코딩에 실패했습니다."
        case .serverError(let statusCode, let message):
            return "[오류 \(statusCode)] \(message)"
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        case .tokenExpiredError:
            return "인증이 만료되었습니다. 다시 로그인해주세요."
        }
    }
}


public struct ErrorResponse: Decodable {
    let code : String
    let message: String
}
