// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit

import CoreModule
import Network

class SignUpVC: UIViewController, FirebaseTrackable {
    var screenName: String = Tracking.VC.signUpVC
    
    private let signUpView = SignUpView()
    
    private let networkService = AuthService()
    let navigationBarManager = NavigationBarManager()
    let validationManager = ValidationManager()
    private let errorHandler = NetworkErrorHandler()
    
    var isEmailDuplicate : Bool = true
    var textFields: [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background
        setupUI()
        setupActions()
        setupNavigationBar()
        hideKeyboardWhenTappedAround()
        view.addSubview(indicator)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.view.addSubview(indicator)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
    }
    
    private func setupNavigationBar() {
        navigationBarManager.setTitle(to: navigationItem, title: "가입하기", textColor: AppColor.black)
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    private func setupUI(){
        view.addSubview(signUpView)
        signUpView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupActions() {
        signUpView.usernameField.textField.addTarget(self, action: #selector(usernameValidate), for: .editingChanged)
        signUpView.checkEmailButton.addTarget(self, action: #selector(checkEmailDuplicate), for: .touchUpInside)
        signUpView.passwordField.textField.addTarget(self, action: #selector(passwordValidate), for: .editingChanged)
        signUpView.confirmPasswordField.textField.addTarget(self, action: #selector(confirmPasswordValidate), for: .editingChanged)
        
        signUpView.signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        
        textFields = [signUpView.usernameField.textField, signUpView.passwordField.textField, signUpView.confirmPasswordField.textField]
        
        for textField in textFields {
            textField.delegate = self
        }
    }
    
    //MARK: - Button Funcs
    @objc private func signupButtonTapped() {
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.signupBtnTapped, fileName: #file)
        self.view.showBlockingView()
        let signUpDTO = networkService.makeJoinDTO(username: signUpView.usernameField.text!, password: signUpView.passwordField.text!, rePassword: signUpView.confirmPasswordField.text!)
        
        Task {
            do{
                let _ = try await networkService.join(data: signUpDTO)
                self.view.hideBlockingView()
                self.goToLoginView()
            } catch {
                self.view.hideBlockingView()
                errorHandler.handleNetworkError(error, in: self)
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
            return
        }
        view.showBlockingView()
        Task {
            await validationManager.checkEmailDuplicate(email: email, view: signUpView.usernameField)
            self.view.hideBlockingView()
            self.validateInputs()
        }
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
        guard let navigationController = self.navigationController else {
            return
        }
        
        if let targetIndex = navigationController.viewControllers.firstIndex(where: { $0 is SelectLoginTypeVC }) {
            let targetVC = navigationController.viewControllers[targetIndex]
            navigationController.popToViewController(targetVC, animated: true)
        } else {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    @objc private func goToLoginView() {
        let loginViewController = LoginVC()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
}

extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let index = textFields.firstIndex(of: textField), index < textFields.count - 1 {
            textFields[index + 1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
