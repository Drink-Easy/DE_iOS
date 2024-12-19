//
//  SelectLoginViewController.swift
//  Drink-EG
//
//  Created by 이현주 on 7/30/24.
//

import UIKit
import SnapKit
import AuthenticationServices
import Moya
import SwiftyToaster

class SelectLoginViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {

    let provider = MoyaProvider<LoginAPI>()
    let loginButton = UIButton(type: .system)
    
    let kakaoButton = UIButton(type: .system)
    let appleButton = ASAuthorizationAppleIDButton(type: .default, style: .white)
    
    let joinButton = UIButton(type: .system)
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "select1")
        return iv
    }()
    
    private let label: UILabel = {
        let l = UILabel()
        l.text = "아직 회원이 아니신가요?"
        l.textColor = UIColor(hue: 0, saturation: 0, brightness: 0.71, alpha: 1.0)
        l.font = UIFont.boldSystemFont(ofSize: 14)
        
        return l
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named:"icon_back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named:"icon_back")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = .white
        
        view.backgroundColor = .black
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupUI() {
        configureLoginButton()
        configureKakaoButton()
        configureAppleButton()
        configureJoinButton()
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(100)
            make.width.lessThanOrEqualTo(165)
            make.height.equalTo(imageView.snp.width)
        }
        
        let buttonStackView = UIStackView(arrangedSubviews: [kakaoButton, appleButton])
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 12
        
        view.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(100)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(33)
            make.height.greaterThanOrEqualTo(132)
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(buttonStackView.snp.bottom).offset(48)
            make.leading.trailing.equalTo(buttonStackView)
            make.height.equalTo(60)
        }
        
        let joinStackView = UIStackView(arrangedSubviews: [label, joinButton])
        joinStackView.axis = .horizontal
        joinStackView.distribution = .fillProportionally
        joinStackView.spacing = 6
        
        view.addSubview(joinStackView)
        joinStackView.snp.makeConstraints { make in
//            make.top.equalTo(loginButton.snp.bottom).offset(50)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.greaterThanOrEqualTo(200)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(25)
        }
    }
    
    private func configureLoginButton() {
        loginButton.setTitle("로그인", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.contentHorizontalAlignment = .center
        
        loginButton.backgroundColor = UIColor(hex: "#FF6F62")
        loginButton.layer.cornerRadius = 16
        loginButton.layer.borderWidth = 0
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func loginButtonTapped() {
        let loginViewController = LoginViewController()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    private func configureKakaoButton() {
        kakaoButton.setTitle("Sign in with Kakao", for: .normal)
        kakaoButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        kakaoButton.setTitleColor(UIColor(hex: "#191919"), for: .normal)
        kakaoButton.contentHorizontalAlignment = .center
        
        //카카오 이미지를 아이콘 포멧 이미지에 맞게 바꿈
        kakaoButton.setImage(UIImage(named: "kakao")?.withRenderingMode(.alwaysOriginal), for: .normal)
        kakaoButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        
        kakaoButton.backgroundColor = UIColor(hex: "#FFEA75")
        kakaoButton.layer.cornerRadius = 6
//        kakaoButton.layer.borderWidth = 2
//        kakaoButton.layer.borderColor = UIColor.white.cgColor.copy(alpha: 0.1)
    }
    
    private func configureAppleButton() {
        appleButton.addTarget(self, action: #selector(handleAuthorizationAppleIDButtonPress), for: .touchUpInside)
    }
    
    //MARK: - Apple Login delegate
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            
            if let identityToken = appleIDCredential.identityToken,
               let identityTokenString = String(data: identityToken, encoding: .utf8) {
                postAppleLogin(token: identityTokenString) { isSuccess in
                    if isSuccess {
                        self.goToNextView()
                    } else {
                        print("로그인 실패")
                        Toaster.shared.makeToast("400 Bad Request", .short)
                    }
                }
            }
            
        case let passwordCredential as ASPasswordCredential:
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
//            print("username: \(username)")
//            print("password: \(password)")
        default:
            break
        }
    }
    
    private func goToNextView() {
        if LoginViewController.isFirstLogin {
            let enterTasteTestViewController = EnterTasteTestViewController()
            navigationController?.pushViewController(enterTasteTestViewController, animated: true)
        } else {
            let homeViewController = HomeViewController()
            navigationController?.pushViewController(homeViewController, animated: true)
        }
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 로그인 실패(유저의 취소도 포함)
        print("login failed - \(error.localizedDescription)")
    }
    
    //MARK: - Login API
    private func postAppleLogin(token: String, completion: @escaping (Bool) -> Void) {
        provider.request(.postAppleLogin(identityTokenString: token)) { result in
            switch result {
            case .success(let response):
                if let httpResponse = response.response,
                   let setCookie = httpResponse.allHeaderFields["Set-Cookie"] as? String {
                    let cookies = HTTPCookie.cookies(withResponseHeaderFields: ["Set-Cookie": setCookie], for: httpResponse.url!)
                    
                    for cookie in cookies {
                        HTTPCookieStorage.shared.setCookie(cookie)
                    }
                    do {
                        let data = try response.map(AppleLoginResponse.self)
                        LoginViewController.isFirstLogin = data.result.isFirst
                        print(data)
                    } catch {
                        completion(false)
                    }
                }
                completion(true)
            case .failure(let error):
                print("Request failed: \(error)")
                completion(false)
            }
        }
    }
    
    
    private func configureJoinButton() {
        joinButton.setTitle("회원가입", for: .normal)
        joinButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        joinButton.setTitleColor(UIColor(hex: "#FF6F62"), for: .normal)
        joinButton.contentHorizontalAlignment = .center
        
        joinButton.backgroundColor = .clear
        joinButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
    }
    
    @objc private func joinButtonTapped() {
        let joinViewController = JoinViewController()
        navigationController?.pushViewController(joinViewController, animated: true)
    }
}
