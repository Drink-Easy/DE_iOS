// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import Combine

import KakaoSDKAuth
import KakaoSDKUser
import KeychainSwift

public class KakaoAuthVM: ObservableObject {
    
    public var subscriptions = Set<AnyCancellable>()

    @Published public var isLoggedIn: Bool = false
    @Published public var errorMessage: String? // 에러 메시지를 저장하는 변수
    
    // 사용자 토큰 저장을 위한 변수
    @Published public private(set) var oauthToken: String? {
        didSet {
            isLoggedIn = oauthToken != nil
        }
    }
    
    public init() {
        print("KakaoAuthVM - init() called")
    }
    
    @MainActor
    public func kakaoLogin(completion: @escaping (Bool) -> Void) {
        if UserApi.isKakaoTalkLoginAvailable() {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                if let error = error {
                    print("카카오톡 로그인 실패: \(error.localizedDescription)")
                    completion(false)
                } else if oauthToken != nil {
//                    AccountSettingsVC.hasKakaoTokens = true
                    print("카카오톡 로그인 성공")
                    completion(true)
                }
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print("카카오 계정 로그인 실패: \(error.localizedDescription)")
                    completion(false)
                } else if oauthToken != nil {
//                    AccountSettingsVC.hasKakaoTokens = true
                    print("카카오 계정 로그인 성공")
                    completion(true)
                }
            }
        }
    }
    
    @MainActor
    public func kakaoLogout() {
        Task {
            if await handleKakaoLogOut() {
                self.isLoggedIn = false
            }
        }
    }
    
    public func handleKakaoLogOut() async -> Bool {
        await withCheckedContinuation { continuation in
            UserApi.shared.logout { [weak self] (error) in
                if let error = error {
                    print(error)
                    self?.errorMessage = "로그아웃 실패: \(error.localizedDescription)"
                    continuation.resume(returning: false)
                } else {
                    print("logout() success.")
                    continuation.resume(returning: true)
                }
            }
        }
    }
    
    public func unlinkKakaoAccount(completion : @escaping (Bool) -> Void) {
        UserApi.shared.unlink { error in
            if let error = error {
                print("🔴 카카오 계정 연동 해제 실패: \(error.localizedDescription)")
                completion(false)
            }
            print("🟢 카카오 계정 연동 해제 성공")
            completion(true)
        }
    }
    
    public func unlinkKakaoAccount() async -> Bool {
        await withCheckedContinuation { continuation in
            UserApi.shared.unlink { error in
                if let error = error {
                    print("🔴 카카오 계정 연동 해제 실패: \(error.localizedDescription)")
                    continuation.resume(returning: false) // 실패 시 false 반환
                } else {
                    print("🟢 카카오 계정 연동 해제 성공")
                    continuation.resume(returning: true) // 성공 시 true 반환
                }
            }
        }
    }
}
