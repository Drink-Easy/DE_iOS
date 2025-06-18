// Copyright © 2025 DRINKIG. All rights reserved

import UIKit
import Combine

import KeychainSwift
import Network
import CoreModule

import AuthenticationServices
import KakaoSDKUser
import FirebaseAnalytics

final class SelectLoginViewModel {
    
    // MARK: - Input & Output
    enum Input {
        // 카카오 로그인 버튼 눌림
        case kakaoLogin
        // 애플 로그인 버튼 눌림
        case appleLogin
    }
    
    enum Output {
        // 로딩 상태 전달
        case loading(Bool)
        case success(Bool)
        case failed(Error)
    }
    
    let input = PassthroughSubject<Input, Never>()
    let output = CurrentValueSubject<Output?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()
    
    private var kakaoAuthVM: KakaoAuthVM
    private var appleLoginDto : AppleLoginRequestDTO?
    private let networkService: AuthService
    
    // MARK: - Init
    init(
        kakaoAuthVM: KakaoAuthVM,
        networkService: AuthService
    ) {
        self.kakaoAuthVM = kakaoAuthVM
        self.networkService = networkService
        
        bind()
    }
    
    // MARK: - Bind (Input -> Output)
    func bind() {
        input
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .kakaoLogin:
                    Task {
                        await self?.kakaoLogin()
                    }
                case .appleLogin:
                    print("애플로그인선택")
                }
            }
            .store(in: &cancellables)
    }
}

private extension SelectLoginViewModel {
    @MainActor
    func kakaoLogin() {
        self.kakaoAuthVM.kakaoLogin { success in
            if success {
                UserApi.shared.me { (user, error) in
                    if let error = error {
                        return
                    }
                    
                    guard let userID = user?.id else {
                        return
                    }
                    guard let userEmail = user?.kakaoAccount?.email else {
                        return
                    }
                    let userIDString = String(userID)
                    
                    self.kakaoLoginProceed(userIDString, userEmail: userEmail)
                }
            }
        }
    }
    
    private func kakaoLoginProceed(_ userIDString: String, userEmail: String) {
        let kakaoDTO = self.networkService.makeKakaoDTO(username: userIDString, email: userEmail)
        output.send(.loading(true))
        
        Task {
            do {
                let response = try await networkService.kakaoLogin(data: kakaoDTO)
                Analytics.setUserID("\(response.id)") // 유저 아이디
                
                _ = await MainActor.run {
                    output.send(.loading(false))
                    SelectLoginTypeVC.keychain.set(response.isFirst, forKey: "isFirst")
                    
                    output.send(.success(response.isFirst))
                }
            } catch {
                output.send(.failed(error))
            }
        }
    }
}
