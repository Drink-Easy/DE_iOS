// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

enum NetworkError: Error {
    case networkError
    case decodingError
    case serverError(message: String)
    case unknown
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "A network error occurred."
        case .decodingError:
            return "Failed to decode the response."
        case .serverError(let message):
            return message
        case .unknown:
            return "An unknown error occurred."
        }
    }
}


struct ErrorResponse: Decodable {
    let message: String
}
