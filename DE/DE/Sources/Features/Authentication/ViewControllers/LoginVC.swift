// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule
import Network


class LoginVC: UIViewController {
    // MARK: - Properties
    private let loginView = LoginView() // LoginView 인스턴스
    private let navigationBarManager = NavigationBarManager()
    let validationManager = ValidationManager()

    
    public static var isFirstLogin : Bool = true
    
    override func loadView() {
        view = loginView // 커스텀 뷰 사용
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        
        setupActions()
        setupNavigationBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    // MARK: - 네비게이션 바 설정
    private func setupNavigationBar() {
        navigationBarManager.setTitle(
            to: navigationItem,
            title: "로그인",
            textColor: AppColor.black!
        )
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(backButtonTapped),
            tintColor: AppColor.gray80!
        )
    }
    
    // MARK: - Action 설정
    private func setupActions() {
        loginView.emailField.textField.addTarget(self, action: #selector(emailValidate), for: .editingChanged)
        loginView.passwordField.textField.addTarget(self, action: #selector(passwordValidate), for: .editingChanged)
        loginView.emailSaveCheckBox.addTarget(self, action: #selector(emailSaveCheckBoxTapped), for: .touchUpInside)
        loginView.joinStackView.setJoinButtonAction(target: self, action: #selector(joinButtonTapped))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }

    @objc func emailValidate() {
        validationManager.isEmailValid = validationManager.validateEmail(loginView.emailField)
        validateInputs()
    }
    
    @objc func passwordValidate() {
        validationManager.isPasswordValid = validationManager.validatePassword(loginView.passwordField)
        validateInputs()
    }
    
    private func validateInputs() {
            let isValid = validationManager.isUsernameValid &&
                          validationManager.isEmailValid &&
                          validationManager.isPasswordValid &&
                          validationManager.isConfirmPasswordValid &&
                          validationManager.isTermsAgreeValid
            
//            signUpButton.isEnabled = isValid
//            signUpButton.backgroundColor = isValid ? Constants.Colors.skyblue : Constants.Colors.gray600
        }
        
    @objc private func emailSaveCheckBoxTapped() {
        loginView.emailSaveCheckBox.isSelected.toggle()
//        updateAllAgreeState()
//        termsAgreeValidate()
    }
    
    @objc private func loginButtonTapped() {
        // API 호출
    }
        
    private func goToNextView() {
        if LoginVC.isFirstLogin {
            let enterTasteTestViewController = TestVC()
            navigationController?.pushViewController(enterTasteTestViewController, animated: true)
        } else {
            let homeViewController = TestVC()
            navigationController?.pushViewController(homeViewController, animated: true)
        }
    }
    
    @objc private func joinButtonTapped() {
        let joinViewController = SignUpVC()
        navigationController?.pushViewController(joinViewController, animated: true)
    }
    
}
