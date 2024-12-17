//
//  WineNewsAPI.swift
//  Drink-EG
//
//  Created by 김도연 on 8/12/24.
//

import Foundation
import Moya

enum WineNewsAPI {
    case getUser(id: Int)
    case createUser(name: String, email: String)
    case updateUser(id: Int, name: String, email: String)
    case deleteUser(id: Int)
}
