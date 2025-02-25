// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import AuthenticationServices
import Network
import CoreModule
import FirebaseAnalytics

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
        showToastMessage(message: "[애플 로그인 실패] \(error.localizedDescription)", yPosition: view.frame.height * 0.75)
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let _ = appleIDCredential.user
        
            if let identityToken = appleIDCredential.identityToken,
               let identityTokenString = String(data: identityToken, encoding: .utf8) {
                // 2. 새로운 토큰 저장 및 DTO 생성
                SelectLoginTypeVC.keychain.set(identityTokenString, forKey: "AppleIDToken")
                self.appleLoginDto = networkService.makeAppleDTO(idToken: identityTokenString)
            } else {
                // 3. identityToken이 없는 경우 키체인에서 기존 토큰 조회
                guard let cachedTokenString = SelectLoginTypeVC.keychain.get("AppleIDToken") else {
                    showToastMessage(message: "애플ID 토큰 발급 실패 : 애플 로그인 실패", yPosition: view.frame.height * 0.75)
                    return
                }
                // 4. 기존 토큰으로 DTO 생성
                self.appleLoginDto = networkService.makeAppleDTO(idToken: cachedTokenString)
            }
            
            guard let loginData = self.appleLoginDto else {
                showToastMessage(message: "데이터 생성 실패 : 애플 로그인 실패", yPosition: view.frame.height * 0.75)
                return
            }
            
            Task {
                self.view.showBlockingView()
                do {
                    let response = try await networkService.appleLogin(data: loginData)
                    Analytics.setUserID("\(response.id)") // 유저 아이디
                    DispatchQueue.main.async {
                        self.view.hideBlockingView()
                        SelectLoginTypeVC.keychain.set(response.isFirst, forKey: "isFirst")
                        self.goToNextView(response.isFirst)
                    }
                } catch {
                    errorHandler.handleNetworkError(error, in: self)
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
