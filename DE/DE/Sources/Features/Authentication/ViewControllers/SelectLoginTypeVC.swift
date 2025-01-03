// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import SwiftyToaster
import KeychainSwift

import Network
import CoreModule
import HomeModule

import AuthenticationServices
import KakaoSDKUser


public class SelectLoginTypeVC: UIViewController {
    
    public static let keychain = KeychainSwift()
    lazy var kakaoAuthVM: KakaoAuthVM = KakaoAuthVM()
    public var appleLoginDto : AppleLoginRequestDTO?
    let networkService = AuthService()
    
    private let mainView = SelectLoginTypeView()
    
    // MARK: - Life Cycle
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override func loadView() {
        self.view = mainView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        setupActions()
    }
    
    // MARK: - Setup Methods
    private func setupActions() {
        mainView.kakaoButton.addTarget(self, action: #selector(kakaoButtonTapped), for: .touchUpInside)
        mainView.appleButton.addTarget(self, action: #selector(appleButtonTapped), for: .touchUpInside)
        mainView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        mainView.joinStackView.setJoinButtonAction(target: self, action: #selector(joinButtonTapped))
    }
    
    // MARK: - Actions
    @objc private func kakaoButtonTapped() {
        self.kakaoAuthVM.kakaoLogin { success in
            if success {
                UserApi.shared.me { (user, error) in
                    if let error = error {
                        print("에러 발생: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            Toaster.shared.makeToast("사용자 정보 가져오기 실패")
                        }
                        return
                    }
                    
                    guard let userID = user?.id else {
                        print("user id가 nil입니다.")
                        return
                    }
                    guard let userEmail = user?.kakaoAccount?.email else {
                        print("userEmail가 nil입니다.")
                        return
                    }
                    let userIDString = String(userID)
                    
                    self.kakaoLoginProceed(userIDString, userEmail: userEmail)
                }
            } else {
                print("카카오 회원가입 실패")
            }
        }
    }
    
    @objc private func appleButtonTapped() {
        startAppleLoginProcess()
    }
    
    private func kakaoLoginProceed(_ userIDString: String, userEmail: String) {
        let kakaoDTO = self.networkService.makeKakaoDTO(username: userIDString, email: userEmail)
        self.networkService.kakaoLogin(data: kakaoDTO) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                print("카카오 로그인 성공")
                self.goToNextView(response.isFirst)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc private func loginButtonTapped() {
        let loginViewController = LoginVC()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    @objc private func joinButtonTapped() {
        let joinViewController = SignUpVC()
        navigationController?.pushViewController(joinViewController, animated: true)
    }
    
    func goToNextView(_ isFirstLogin: Bool) {
        if isFirstLogin {
            let enterTasteTestViewController = SplashVC()
            navigationController?.pushViewController(enterTasteTestViewController, animated: true)
        } else {
            let homeViewController = MainTabBarController()
            navigationController?.pushViewController(homeViewController, animated: true)
        }
    }
}
