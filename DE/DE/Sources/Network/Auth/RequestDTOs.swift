// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

// 애플 로그인
struct AppleLoginRequestDTO : Codable {
    let identityToken : String
}

// 자체 회원가입
struct JoinDTO : Codable {
    let username : String
    let password : String
    let rePassword : String
}

// 사용자 초기 정보 추가
struct MemberRequestDTO : Codable {
    let name : String
    let isNewBie : Bool
    let monthPrice : Int
    let wineSort : [String]
    let wineArea : [String]
    let wineVariety : [String]
    let region : String
}
