// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Moya

import CoreModule
import Network

class SignUpVC: UIViewController {
    private let signUpView = SignUpView()
    
    private let networkService = AuthService()
    let navigationBarManager = NavigationBarManager()
    let validationManager = ValidationManager()
    
    var isEmailDuplicate : Bool = true
    
    override func loadView() {
        view = signUpView
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
    
    private func setupNavigationBar() {
        navigationBarManager.setTitle(to: navigationItem, title: "가입하기", textColor: AppColor.black!)
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(backButtonTapped),
            tintColor: AppColor.gray70!
        )
    }
    
    private func setupActions() {
        signUpView.usernameField.textField.addTarget(self, action: #selector(usernameValidate), for: .editingChanged)
        signUpView.checkEmailButton.addTarget(self, action: #selector(checkEmailDuplicate), for: .touchUpInside)
        signUpView.passwordField.textField.addTarget(self, action: #selector(passwordValidate), for: .editingChanged)
        signUpView.confirmPasswordField.textField.addTarget(self, action: #selector(confirmPasswordValidate), for: .editingChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        signUpView.signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    //MARK: - Button Funcs
    @objc private func signupButtonTapped() {
        let signUpDTO = networkService.makeJoinDTO(username: signUpView.usernameField.text!, password: signUpView.passwordField.text!, rePassword: signUpView.confirmPasswordField.text!)
        
        networkService.join(data: signUpDTO) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                self.goToLoginView()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func usernameValidate() {
        validationManager.isEmailDuplicate = true
        validationManager.isUsernameValid = validationManager.validateUsername(signUpView.usernameField)
        validateInputs()
    }
    
    @objc private func checkEmailDuplicate() {
        guard let email = signUpView.usernameField.text, !email.isEmpty else {
            print("이메일이 없습니다")
            return
        }
        
        validationManager.checkEmailDuplicate(email: email, view: signUpView.usernameField)
    }
    
    @objc func passwordValidate() {
        validationManager.isPasswordValid = validationManager.validatePassword(signUpView.passwordField)
        validateInputs()
    }
    
    @objc func confirmPasswordValidate() {
        validationManager.isConfirmPasswordValid = validationManager.validateConfirmPassword(signUpView.confirmPasswordField, password: signUpView.passwordField.text)
        validateInputs()
    }
    
    private func validateInputs() {
        let isValid = validationManager.isUsernameValid &&
        validationManager.isPasswordValid &&
        validationManager.isConfirmPasswordValid && !validationManager.isEmailDuplicate
        
        signUpView.signupButton.isEnabled = isValid
        signUpView.signupButton.isEnabled(isEnabled: isValid)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func goToLoginView() {
        let loginViewController = LoginVC()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
}

