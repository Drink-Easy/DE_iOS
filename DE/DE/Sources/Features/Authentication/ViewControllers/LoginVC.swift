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
    
    override func loadView() {
        view = loginView // 커스텀 뷰 사용
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        validationManager.isEmailDuplicate = false
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
            action: #selector(backButtonTapped)
        )
    }
    
    // MARK: - Action 설정
    private func setupActions() {
        loginView.usernameField.textField.addTarget(self, action: #selector(usernameValidate), for: .editingChanged)
        loginView.passwordField.textField.addTarget(self, action: #selector(passwordValidate), for: .editingChanged)
        loginView.idSaveCheckBox.addTarget(self, action: #selector(idSaveCheckBoxTapped), for: .touchUpInside)
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
                self.goToNextView(response.isFirst)
            case .failure(let error):
                print(error)
                self.loginView.loginButton.isEnabled = false
                self.loginView.loginButton.isEnabled(isEnabled: false)
                self.validationManager.showValidationError(loginView.usernameField, message: "")
                self.validationManager.showValidationError(loginView.passwordField, message: "회원 정보를 다시 확인해 주세요")
            }
        }
    }
    
    private func goToNextView(_ isFirstLogin: Bool) {
        if isFirstLogin {
            let enterTasteTestViewController = TermsOfServiceVC()
            navigationController?.pushViewController(enterTasteTestViewController, animated: true)
        } else {
            let homeViewController = MainTabBarController()
            navigationController?.pushViewController(homeViewController, animated: true)
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
