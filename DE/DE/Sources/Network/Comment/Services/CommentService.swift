// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import Moya

final class CommentService {
    private let provider : MoyaProvider<CommentEndpoints>
    
    init(provider: MoyaProvider<CommentEndpoints> = MoyaProvider<CommentEndpoints>()) {
        self.provider = provider
    }
}
