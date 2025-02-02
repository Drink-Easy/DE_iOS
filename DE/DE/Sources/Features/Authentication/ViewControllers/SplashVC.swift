// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import Moya
import SnapKit

import KeychainSwift
import SwiftyToaster
import AppTrackingTransparency
import AdSupport

import Network
import CoreModule

// SelectLoginTypeVC.keychain.getBool("isFirst")

public class SplashVC : UIViewController {
    
    let networkService = AuthService()
    
    var refreshToken: String = ""
    var ExpiresAt: Date = Date()
    
    private lazy var logoImage: UIImageView = {
        let logoImage = UIImageView()
        logoImage.image = UIImage(named: "logo")
        return logoImage
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
        
        // 현재 뷰 컨트롤러가 내비게이션 컨트롤러 안에 있는지 확인
        if self.navigationController == nil {
            // 네비게이션 컨트롤러가 없으면 새로 설정
            let navController = UINavigationController(rootViewController: self)
            navController.modalPresentationStyle = .fullScreen
            
            // 현재 창의 rootViewController 교체
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = navController
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.checkAuthenticationStatus()
        }
    }
    
    func setupViews() {
        view.backgroundColor = AppColor.bgGray
        view.addSubview(logoImage)
    }
    
    func checkAuthenticationStatus() {
        
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                if cookie.name == "accessToken" {
                    if let expires = cookie.expiresDate {
                        ExpiresAt = expires
                    }
                }
                if cookie.name == "refreshToken" {
                    refreshToken = cookie.value
                }
            }
        }
        
        //토큰 유효
        if Date() < ExpiresAt {
            checkIsFirst()
        } else {
            networkService.reissueToken { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    checkIsFirst()
                case .failure(let error):
                    navigateToOnBoaringScreen()
                    print(error)
                }
            }
        }
    }
    
    func checkIsFirst() {
        let isFirstString = SelectLoginTypeVC.keychain.getBool("isFirst")
        if isFirstString == true || isFirstString == nil {
            navigateToWelcomeScreen()
        } else { navigateToMainScreen() }
    }
    
    func navigateToMainScreen() {
        let mainTabBarController = MainTabBarController()
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = mainTabBarController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        }
    }
    
    func navigateToWelcomeScreen() {
        let vc = TermsOfServiceVC()
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = vc
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        }
    }
    
    func navigateToOnBoaringScreen() {
        let onboardingVC = OnboardingVC()
        self.navigationController?.pushViewController(onboardingVC, animated: true)
    }
    
    func setConstraints() {
        logoImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(Constants.superViewHeight * 0.4)
            make.width.height.equalTo(Constants.superViewWidth * 0.3)
        }
    }

}
