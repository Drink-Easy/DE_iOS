// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

// 최상위 응답 모델
struct ApiResponse<T: Decodable>: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T
}
