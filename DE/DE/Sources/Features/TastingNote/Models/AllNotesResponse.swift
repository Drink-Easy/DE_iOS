// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

struct AllNotesResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: [Note]
}
