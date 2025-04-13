// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import SwiftyToaster
import KeychainSwift

import Network
import CoreModule

import AuthenticationServices
import KakaoSDKUser
import FirebaseAnalytics


public class SelectLoginTypeVC: UIViewController, FirebaseTrackable, UIGestureRecognizerDelegate {
    public var screenName: String = Tracking.VC.selectLoginTypeVC
    
    public static let keychain = KeychainSwift()
    lazy var kakaoAuthVM: KakaoAuthVM = KakaoAuthVM()
    public var appleLoginDto : AppleLoginRequestDTO?
    let networkService = AuthService()
    let errorHandler = NetworkErrorHandler()
    
    private let mainView = SelectLoginTypeView()
    
    // MARK: - Life Cycle
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    public override func loadView() {
        self.view = mainView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background
        setupActions()
        view.addSubview(indicator)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
    }
    
    // MARK: - Setup Methods
    private func setupActions() {
        mainView.kakaoButton.addTarget(self, action: #selector(kakaoButtonTapped), for: .touchUpInside)
        mainView.appleButton.addTarget(self, action: #selector(appleButtonTapped), for: .touchUpInside)
        mainView.loginButton.addTarget(self, action: #selector(goToLoginVC), for: .touchUpInside)
        mainView.joinStackView.setJoinButtonAction(target: self, action: #selector(joinButtonTapped))
    }
    
    // MARK: - Actions
    @objc private func kakaoButtonTapped() {
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.kakaoBtnTapped, fileName: #file)
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
    
    @objc private func appleButtonTapped() {
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.appleBtnTapped, fileName: #file)
        startAppleLoginProcess()
    }
    
    private func kakaoLoginProceed(_ userIDString: String, userEmail: String) {
        let kakaoDTO = self.networkService.makeKakaoDTO(username: userIDString, email: userEmail)
        self.view.showBlockingView()
        Task {
            do {
                let response = try await networkService.kakaoLogin(data: kakaoDTO)
                Analytics.setUserID("\(response.id)") // 유저 아이디
                DispatchQueue.main.async {
                    self.view.hideBlockingView()
                    SelectLoginTypeVC.keychain.set(response.isFirst, forKey: "isFirst")
                    self.goToNextView(response.isFirst)
                }
            } catch {
                self.view.hideBlockingView()
                errorHandler.handleNetworkError(error, in: self)
            }
        }
    }
    
    @objc private func goToLoginVC() {
        let loginViewController = LoginVC()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    @objc private func joinButtonTapped() {
        let joinViewController = SignUpVC()
        navigationController?.pushViewController(joinViewController, animated: true)
    }
    
    func goToNextView(_ isFirstLogin: Bool) {
        if isFirstLogin {
            let enterTasteTestViewController = TermsOfServiceVC()
            navigationController?.pushViewController(enterTasteTestViewController, animated: true)
        } else {
            let homeViewController = MainTabBarController()
            navigationController?.pushViewController(homeViewController, animated: true)
        }
    }
    
}
