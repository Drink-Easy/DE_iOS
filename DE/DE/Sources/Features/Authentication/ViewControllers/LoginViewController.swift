// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Moya
import SwiftyToaster
import CoreModule
import Then

class LoginViewController: UIViewController, UITextFieldDelegate {
    public static var isFirstLogin : Bool = true
    
    var loginDTO : JoinNLoginRequest?
    
    private lazy var emailField: CustomLabelTextFieldView = {
        let field = CustomLabelTextFieldView(descriptionLabelText: "이메일", textFieldPlaceholder: "이메일을 입력해 주세요", validationText: "사용할 수 없는 이메일입니다")
        field.textField.keyboardType = .emailAddress
        return field
    }()
    private lazy var passwordField: CustomLabelTextFieldView = {
        let field = CustomLabelTextFieldView(descriptionLabelText: "비밀번호", textFieldPlaceholder: "비밀번호를 입력해 주세요", validationText: "8~20자 이내 영문자, 숫자, 특수문자의 조합")
        field.textField.isSecureTextEntry = true
        field.textField.textContentType = .newPassword
        return field
    }()
    
    private let joinStackView = JoinStackView()
    
    private lazy var emailSaveCheckBox = CustomCheckSquareButton(title: "아이디 저장하기")
    
    let idSearchButton = UIButton(type: .system)
    
    private let loginButton = CustomButton(
        title: "로그인",
        titleColor: .white,
        backgroundColor: AppColor.purple100!
    ).then {
        $0.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named:"icon_back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named:"icon_back")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = .white
        
        
        let titleView = UIView()

        self.navigationItem.titleView = titleView
        
        view.backgroundColor = .black
        
        setupUI()
        setupConstraints()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        [emailField,passwordField,emailSaveCheckBox,idSearchButton,joinStackView,loginButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        emailField.snp.makeConstraints { make in
            make.top.equalTo(Constants.superViewHeight * 0.4)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        emailSaveCheckBox.snp.makeConstraints { make in
            make.top.equalTo(Constants.superViewHeight * 0.7)
            make.leading.equalToSuperview().inset(16)
        }
        idSearchButton.snp.makeConstraints { make in
            make.centerY.equalTo(emailSaveCheckBox)
        }
        joinStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview() // 수평 가운데 정렬
            make.bottom.equalToSuperview().offset(-50) // 하단에서 위로 50pt
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(Constants.superViewHeight * 0.8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func setupActions(){
        emailField.textField.addTarget(self, action: #selector(emailValidate), for: .editingChanged)
        passwordField.textField.addTarget(self, action: #selector(passwordValidate), for: .editingChanged)
        
        emailSaveCheckBox.addTarget(self, action: #selector(termsTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func emailValidate() {
        self.view.endEditing(true)
    }
    
    @objc private func passwordValidate() {
        self.view.endEditing(true)
    }
    
    @objc private func termsTapped() {
        self.view.endEditing(true)
    }
    
    @objc private func loginButtonTapped() {
        callLoginAPI { [weak self] isSuccess in
            if isSuccess {
                if LoginViewController.isFirstLogin {
                    self?.goToNextView()
                } else {
                    self?.goToHomeView()
                }
                
            } else {
                print("로그인 실패")
                Toaster.shared.makeToast("400 Bad Request : Failed to Login", .short)
            }
        }
    }
    
    private func goToNextView() {
        if LoginViewController.isFirstLogin {
            let enterTasteTestViewController = TestVC()
            navigationController?.pushViewController(enterTasteTestViewController, animated: true)
        } else {
            let homeViewController = TestVC()
            navigationController?.pushViewController(homeViewController, animated: true)
        }
    }
    
    private func goToHomeView() {
        let homeViewController = TestVC()
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    
    @objc private func joinButtonTapped() {
        let joinViewController = JoinViewController()
        navigationController?.pushViewController(joinViewController, animated: true)
    }
    
    // 배경 클릭시 키보드 내림  ==> view 에 터치가 들어오면 에디팅모드를 끝냄.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)  //firstresponder가 전부 사라짐
    }
    
    private func callLoginAPI(completion: @escaping (Bool) -> Void) {
//        if let data = self.loginDTO {
//            provider.request(.postLogin(data: data)) { result in
//                switch result {
//                case .success(let response):
//                    if let httpResponse = response.response,
//                       let setCookie = httpResponse.allHeaderFields["Set-Cookie"] as? String {
//                        let cookies = HTTPCookie.cookies(withResponseHeaderFields: ["Set-Cookie": setCookie], for: httpResponse.url!)
//                        
//                        for cookie in cookies {
//                            HTTPCookieStorage.shared.setCookie(cookie)
//                        }
//                        do {
//                            let data = try response.map(LoginResponse.self)
//                            LoginViewController.isFirstLogin = data.isFirst
//                        } catch {
//                            completion(false)
//                        }
//                    }
//                    completion(true)
//                case .failure(let error):
//                    print("Request failed: \(error)")
//                    completion(false)
//                }
//            }
//        }
    }
}
