// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import AuthenticationServices
import Network
import CoreModule

// AccountInfoViewController 확장

extension AccountInfoViewController: ASAuthorizationControllerDelegate {
    func reAuthenticateWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [] // 재인증 시 추가 정보는 필요 없으므로 빈 배열
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("애플 계정 인증 실패: \(error.localizedDescription)")
    }
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            if let authorizationCodeData = appleIDCredential.authorizationCode,
               let authorizationCode = String(data: authorizationCodeData, encoding: .utf8) {
                let data = memberService.makeDeleteAppleUserRequest(AuthCode: authorizationCode)
                Task {
                    do {
                        let _ = try await memberService.deleteAppleUser(body: data) // 서버에 삭제 요청
                        DispatchQueue.main.async {
                            self.clearForQuit()
                            self.showSplashScreen()
                        }
                    } catch {
                        errorHandler.handleNetworkError(error, in: self)
                    }
                }
            } else {
                showToastMessage(message: "애플 인증 실패 : 인가 코드 발급에 실패했습니다.\n다시 시도해주세요.", yPosition: view.frame.height * 0.75)
            }
        default:
            break
        }
    }
}

extension AccountInfoViewController: ASAuthorizationControllerPresentationContextProviding {
    public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window ?? UIWindow()
    }
    
}
