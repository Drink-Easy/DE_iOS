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
            tintColor: AppColor.gray80!
        )
    }

    private func setupActions() {
        signUpView.emailField.textField.addTarget(self, action: #selector(emailValidate), for: .editingChanged)
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
        // 이거 optional 까줄 이유가 없음
        //         guard let id = self.userID, let pw = self.userPW else {
        //             showAlert(message: "아이디와 비밀번호를 입력해 주세요.")
        //             return
        //         }
        //
        //         let joinDTO = networkService.makeJoinDTO(username: id, password: pw, rePassword: pw)
        //         setLoading(true)
        //
        //         networkService.join(data: joinDTO) { [weak self] result in
        //             guard let self = self else { return }
        //             self.setLoading(false)
        //
        //             switch result {
        //             case .success:
        //                 self.goToLoginView()
        //             case .failure(let error):
        //                 self.handleError(error)
        //             }
        //         }
    }
    
    @objc func emailValidate() {
        validationManager.isEmailValid = validationManager.validateEmail(signUpView.emailField)
        validateInputs()
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
            let isValid = validationManager.isEmailValid &&
                          validationManager.isPasswordValid &&
                          validationManager.isConfirmPasswordValid
            
        signUpView.signupButton.isEnabled = isValid
        signUpView.signupButton.backgroundColor = isValid ? AppColor.purple100 : AppColor.gray80
        }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func goToLoginView() {
        let loginViewController = LoginVC()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    private func showAlert(title: String = "알림", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
}

