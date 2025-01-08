// Copyright © 2024 DRINKIG. All rights reserved

import Foundation

// email check

public struct UsernameCheckRequest: Codable {
    public let username: String
    
    public init(username: String) {
        self.username = username
    }
}

// 애플 로그인
public struct AppleLoginRequestDTO : Codable {
    public let identityToken : String
    
    public init(identityToken: String) {
        self.identityToken = identityToken
    }
}

public struct KakaoLoginRequestDTO : Codable {
    public let kakaoName: String
    public let kakaoEmail: String
    
    public init(kakaoName: String, kakaoEmail: String) {
        self.kakaoName = kakaoName
        self.kakaoEmail = kakaoEmail
    }
}

// 자체 회원가입
public struct JoinDTO : Codable {
    public let username : String
    public let password : String
    public let rePassword : String
    
    public init(username: String, password: String, rePassword: String) {
        self.username = username
        self.password = password
        self.rePassword = rePassword
    }
}

// login
public struct LoginDTO : Codable {
    public let username : String
    public let password : String
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
