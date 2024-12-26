// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import SwiftyToaster
import CoreModule
import Then
import Network

class LoginVC: UIViewController {
    public static var isFirstLogin : Bool = true
    
    private lazy var emailField: CustomLabelTextFieldView = {
        let field = CustomLabelTextFieldView(descriptionImageIcon: "person.fill", descriptionLabelText: "이메일", textFieldPlaceholder: "이메일을 입력해 주세요", validationText: "사용할 수 없는 이메일입니다")
        field.textField.keyboardType = .emailAddress
        return field
    }()
    private lazy var passwordField: CustomLabelTextFieldView = {
        let field = CustomLabelTextFieldView(descriptionImageIcon: "lock.fill", descriptionLabelText: "비밀번호", textFieldPlaceholder: "비밀번호를 입력해 주세요", validationText: "8~20자 이내 영문자, 숫자, 특수문자의 조합")
        field.textField.isSecureTextEntry = true
        field.textField.textContentType = .newPassword
        return field
    }()
    
    private let joinStackView = JoinStackView()
    
    private lazy var emailSaveCheckBox = CustomCheckSquareButton(title: "아이디 저장하기")
    
    private let idSearchButton = UIButton().then {
        $0.setTitle("아이디 / 비밀번호 찾기", for: .normal)
        $0.setTitleColor(UIColor(hex: "#191919"), for: .normal)
        $0.titleLabel?.font =  UIFont.ptdMediumFont(ofSize: 14)
        //        $0.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
    }
    
    private let loginButton = CustomButton(
        title: "로그인",
        titleColor: .white,
        backgroundColor: AppColor.purple100!
    ).then {
        $0.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named:"icon_back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named:"icon_back")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = .white
        
        
        let titleView = UIView()
        
        self.navigationItem.titleView = titleView
        
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupUI() {
        [emailField,passwordField,emailSaveCheckBox,idSearchButton,joinStackView,loginButton].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        emailField.snp.makeConstraints { make in
            make.top.equalTo(Constants.superViewHeight * 0.4)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
        }
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
        }
        emailSaveCheckBox.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(32)
            make.leading.equalToSuperview().inset(Constants.padding)
        }
        idSearchButton.snp.makeConstraints { make in
            make.centerY.equalTo(emailSaveCheckBox)
            make.trailing.equalToSuperview().inset(Constants.padding)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(Constants.superViewHeight * 0.8)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
        }
        joinStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview() // 수평 가운데 정렬
            make.bottom.equalToSuperview().offset(-50) // 하단에서 위로 50pt
        }
    }
    
    private func setupActions(){
        emailField.textField.addTarget(self, action: #selector(emailValidate), for: .editingChanged)
        passwordField.textField.addTarget(self, action: #selector(passwordValidate), for: .editingChanged)
        emailSaveCheckBox.addTarget(self, action: #selector(emailSaveCheckBoxTapped), for: .touchUpInside)
        joinStackView.setJoinButtonAction(target: self, action: #selector(joinButtonTapped))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc private func emailValidate() {
        
    }
    
    @objc private func passwordValidate() {
        
    }
    
    @objc private func emailSaveCheckBoxTapped() {
        
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
    
    private func goToHomeView() {
        let homeViewController = TestVC()
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    @objc private func joinButtonTapped() {
        let joinViewController = SignUpVC()
        navigationController?.pushViewController(joinViewController, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)  //firstresponder가 전부 사라짐
    }
    
}
