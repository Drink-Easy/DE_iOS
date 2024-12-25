// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import AuthenticationServices

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
    
    public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            var authorizationCode : String?
            var identityTokenString : String?
            
            // authCode 발급 확인
            if let authCode = appleIDCredential.authorizationCode,
               let authCodeString = String(data: authCode, encoding: .utf8) {
                authorizationCode = authCodeString
            } else {
                authorizationCode = nil
                print("authcode 발급 실패")
            }
            
            if let identityToken = appleIDCredential.identityToken {
                if let identityTokenString = String(data: identityToken, encoding: .utf8) {
                    
                }
            } else {
                
            }
            
        default :
            break
        }
    }
}

extension SelectLoginTypeVC: ASAuthorizationControllerPresentationContextProviding {
    
}
