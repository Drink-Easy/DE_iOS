// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule
import Network

class LoginVC: UIViewController {
    // MARK: - Properties
    private let loginView = LoginView()
    
    private let navigationBarManager = NavigationBarManager()
    let validationManager = ValidationManager()
    let networkService = AuthService()
    
    var isSavingId : Bool = false
    var usernameString : String = ""
    var textFields: [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        validationManager.isEmailDuplicate = false
        setupUI()
        setupActions()
        setupNavigationBar()
        hideKeyboardWhenTappedAround()
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
            action: #selector(backButtonTapped)
        )
    }
    
    // MARK: - setup Methods
    private func setupUI(){
        view.addSubview(loginView)
        view.addSubview(indicator)
        loginView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupActions() {
        loginView.usernameField.textField.addTarget(self, action: #selector(usernameValidate), for: .editingChanged)
        loginView.passwordField.textField.addTarget(self, action: #selector(passwordValidate), for: .editingChanged)
        loginView.idSaveCheckBox.addTarget(self, action: #selector(idSaveCheckBoxTapped), for: .touchUpInside)
        loginView.joinStackView.setJoinButtonAction(target: self, action: #selector(joinButtonTapped))
        
        loginView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        textFields = [loginView.usernameField.textField, loginView.passwordField.textField]
        
        for textField in textFields {
            textField.delegate = self
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func usernameValidate() {
        validationManager.isUsernameValid = validationManager.validateUsername(loginView.usernameField)
        validateInputs()
    }
    
    @objc func passwordValidate() {
        validationManager.isPasswordValid = validationManager.validatePassword(loginView.passwordField)
        validateInputs()
    }
    
    private func validateInputs() {
        let isValid = validationManager.isUsernameValid &&
        validationManager.isPasswordValid
        
        loginView.loginButton.isEnabled = isValid
        loginView.loginButton.isEnabled(isEnabled: isValid)
    }
    
    @objc private func idSaveCheckBoxTapped() {
        loginView.idSaveCheckBox.isSelected.toggle()
        isSavingId = loginView.idSaveCheckBox.isSelected
    }
    
    @objc private func loginButtonTapped() {
        let loginDTO = networkService.makeLoginDTO(username: loginView.usernameField.text!, password: loginView.passwordField.text!)
        usernameString = loginDTO.username
        self.view.showBlockingView()
        networkService.login(data: loginDTO) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                SelectLoginTypeVC.keychain.set(usernameString, forKey: "savedUserEmail")
                // userId 저장
                saveUserId(userId: response.id) // 현재 로그인한 유저 정보
                Task {
                    await UserDataManager.shared.createUser(userId: response.id)
                }
                self.view.hideBlockingView()
                self.goToNextView(response.isFirst)
            case .failure(let error):
                print(error)
                self.view.hideBlockingView()
                self.loginView.loginButton.isEnabled = false
                self.loginView.loginButton.isEnabled(isEnabled: false)
                self.validationManager.showValidationError(loginView.usernameField, message: "")
                self.validationManager.showValidationError(loginView.passwordField, message: "회원 정보를 다시 확인해 주세요")
            }
            
        }
    }
    
    private func goToNextView(_ isFirstLogin: Bool) {
        if isFirstLogin {
            SelectLoginTypeVC.keychain.set(true, forKey: "isFirst")
            let enterTasteTestViewController = TermsOfServiceVC()
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = enterTasteTestViewController
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
            }
        } else {
            SelectLoginTypeVC.keychain.set(false, forKey: "isFirst")
            let homeViewController = MainTabBarController()
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = homeViewController
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
            }
        }
    }
    
    @objc private func joinButtonTapped() {
        let joinViewController = SignUpVC()
        navigationController?.pushViewController(joinViewController, animated: true)
    }
    
    func fillSavedId() {
        if let id = SelectLoginTypeVC.keychain.get("savedUserId") {
            loginView.usernameField.text = id
        }
    }
    
    func saveUserId(userId : Int) {
        // 로그아웃 시, 이 데이터 모두 삭제
        let userIdString = "\(userId)"
        SelectLoginTypeVC.keychain.set(userIdString, forKey: "userId")
        UserDefaults.standard.set(userId, forKey: "userId")
    }
    
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let index = textFields.firstIndex(of: textField), index < textFields.count - 1 {
            textFields[index + 1].becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
