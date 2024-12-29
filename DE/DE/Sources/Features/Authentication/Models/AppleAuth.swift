// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import AuthenticationServices
import Network

extension SelectLoginTypeVC: ASAuthorizationControllerDelegate {
    public func startAppleLoginProcess() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("애플 로그인 실패: \(error.localizedDescription)")
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user

            // 1. identityToken 존재 여부 확인
            if let identityToken = appleIDCredential.identityToken,
               let identityTokenString = String(data: identityToken, encoding: .utf8) {
                
                // 2. 새로운 토큰 저장 및 DTO 생성
                SelectLoginTypeVC.keychain.set(identityTokenString, forKey: "AppleIDToken")
                self.appleLoginDto = networkService.makeAppleDTO(idToken: identityTokenString)
            } else {
                // 3. identityToken이 없는 경우 키체인에서 기존 토큰 조회
                guard let cachedTokenString = SelectLoginTypeVC.keychain.get("AppleIDToken") else {
                    print("idToken 발급 불가 : 애플 로그인 실패")
                    return
                }
                
                // 4. 기존 토큰으로 DTO 생성
                self.appleLoginDto = networkService.makeAppleDTO(idToken: cachedTokenString)
            }
            
            guard let loginData = self.appleLoginDto else {
                print("로그인 데이터 생성 실패 : 애플 로그인 실패")
                return
            }
            
            networkService.appleLogin(data: loginData) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    self.goToNextView(response.isFirst)
                case .failure(let error):
                    print(error)
                }
            }

        default :
            break
        }
    }
}

extension SelectLoginTypeVC: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
    
}
