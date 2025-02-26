// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit

import KeychainSwift
import SwiftyToaster
import AppTrackingTransparency
import AdSupport
import Then

import Network
import CoreModule
import FirebaseAnalytics

public class SplashVC : UIViewController, FirebaseTrackable {
    public var screenName: String = Tracking.VC.splashVC
    
    let networkService = AuthService()
    private let errorHandler = NetworkErrorHandler()
    var refreshToken: String = ""
    var accessToken: String = ""
    var refreshExpiresAt: Date?
    
    private lazy var logoImage = UIImageView().then { logoImage in
        logoImage.image = UIImage(named: "logo")
    }
    
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
        Analytics.setAnalyticsCollectionEnabled(true)
        Analytics.setUserProperty("false", forName: "debug_mode")
        let isNeedUpdate = UserDefaults.standard.double(forKey: "isNeedUpdate")
        let showStopSign = UserDefaults.standard.bool(forKey: "showStopSign")
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as?Double ?? 1.0
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if showStopSign {
                guard let date = UserDefaults.standard.string(forKey: "signDate") else {
                    return
                }
                self.showAlertView(message: date)
            } else if isNeedUpdate > appVersion {
                self.showUpdateAlertView()
            } else {
                self.checkAuthenticationStatus()
            }
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
    }
    
    func setupViews() {
        view.backgroundColor = AppColor.bgGray
        view.addSubview(logoImage)
    }
    
    func checkAuthenticationStatus() {
        // 저장된 쿠키 없는 경우
        guard let cookies = HTTPCookieStorage.shared.cookies(for: URL(string: API.baseURL)!) else {
            navigateToOnBoaringScreen()
            return
        }
        
        // 리프레시토큰 추출
        if let refreshTokenCookie = cookies.first(where: { $0.name == "refreshToken" }) {
            refreshToken = refreshTokenCookie.value
            refreshExpiresAt = refreshTokenCookie.expiresDate
        }
        
        // 리프레시 토큰 추출 실패
        guard !refreshToken.isEmpty else {
            navigateToOnBoaringScreen()
            return
        }
        
        // 리프레시토큰 유효기간 추출 실패
        guard let refreshTokenExpiresDate = refreshExpiresAt else {
            navigateToOnBoaringScreen()
            return
        }
        
        // 리프레시 토큰 유효기간 검증
        guard Date() < refreshTokenExpiresDate else {
            navigateToOnBoaringScreen()
            return
        }
        
        Task {
            do {
                // 액세스 토큰 재발급
                let _ = try await networkService.reissueTokenAsync()
                checkIsFirst()
            } catch {
                errorHandler.handleNetworkError(error, in: self)
                navigateToOnBoaringScreen()
            }
        }
    }
    
    func checkIsFirst() {
        let isFirstString = SelectLoginTypeVC.keychain.getBool("isFirst")
        if isFirstString == true || isFirstString == nil {
            navigateToWelcomeScreen()
        } else {
            navigateToMainScreen()
        }
    }
    
    func navigateToMainScreen() {
        self.view.hideBlockingView()
        let mainTabBarController = MainTabBarController()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = mainTabBarController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        }
    }
    
    func navigateToWelcomeScreen() {
        self.view.hideBlockingView()
        let vc = TermsOfServiceVC()
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = vc
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        }
        
    }
    
    func navigateToOnBoaringScreen() {
        DispatchQueue.main.async {
            self.view.hideBlockingView()
            let onboardingVC = OnboardingVC()
            self.navigationController?.pushViewController(onboardingVC, animated: true)
        }
    }
    
    func setConstraints() {
        logoImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(Constants.superViewHeight * 0.4)
            make.width.height.equalTo(Constants.superViewWidth * 0.3)
        }
    }
    
}
