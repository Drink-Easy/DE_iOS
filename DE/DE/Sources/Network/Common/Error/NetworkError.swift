// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

public enum NetworkError: Error {
    case networkError(devMessage: String, userMessage: String)
    case decodingError(devMessage: String, userMessage: String)
    case serverError(statusCode: Int, devMessage: String, userMessage: String)
    case unknown
    case tokenExpiredError(statusCode: Int, devMessage: String, userMessage: String)
    case refreshTokenExpiredError(statusCode: Int, devMessage: String, userMessage: String)
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .networkError(let devMessage, let userMessage):
            return userMessage
        case .decodingError(let devMessage, let userMessage):
            return userMessage
        case .serverError(let statusCode, let devMessage, let userMessage):
            return "\(devMessage)"
        case .unknown:
            return "알 수 없는 오류가 발생했습니다. 관리자에게 문의하세요."
        case .tokenExpiredError(let statusCode, let devMessage, let userMessage):
            return "\(devMessage)"
        case .refreshTokenExpiredError(let statusCode, let devMessage, let userMessage):
            return "\(devMessage)"
        }
    }
}


public struct ErrorResponse: Decodable {
    let isSuccess : Bool
    let httpStatus : String
    let code : String
    let message: String
}
