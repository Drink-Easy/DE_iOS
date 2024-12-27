// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import Moya
import SnapKit

import KeychainSwift
import SwiftyToaster
import AppTrackingTransparency
import AdSupport

import Authentication
import Network
import CoreModule
import HomeModule

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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.checkAuthenticationStatus()
        }
    }
    
    func setupViews() {
        view.backgroundColor = .white
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
            navigateToMainScreen()
        } else {
            networkService.reissueToken { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    navigateToMainScreen()
                    print(response)
                case .failure(let error):
                    navigateToOnBoaringScreen()
                    print(error)
                }
            }
        }
    }
    
    func navigateToMainScreen() {
        let mainTabBarController = MainTabBarController()
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = mainTabBarController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        }
    }
    
    func navigateToOnBoaringScreen() {
        let onboardingVC = OnboardingVC()
        onboardingVC.modalPresentationStyle = .fullScreen
        present(onboardingVC, animated: true, completion: nil)
    }
    
    func setConstraints() {
        logoImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(Constants.superViewHeight * 0.4)
            make.width.height.equalTo(Constants.superViewWidth * 0.3)
        }
    }

    
}
