// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Moya
import SwiftyToaster
import CoreModule
import Network

class SignUpVC: UIViewController {
    
    private let networkService = AuthService()
    
    public var userID : String?
    public var userPW : String?
    
    //MARK: - TextFields
    let titleView = UIView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "가입하기"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private lazy var emailField: CustomLabelTextFieldView = {
        let field = CustomLabelTextFieldView(descriptionImageIcon: "person.fill", descriptionLabelText: "이메일", textFieldPlaceholder: "이메일을 입력해 주세요", validationText: "이메일 형식이 올바르지 않습니다")
        field.textField.keyboardType = .emailAddress
        return field
    }()
    private lazy var passwordField: CustomLabelTextFieldView = {
        let field = CustomLabelTextFieldView(descriptionImageIcon: "lock.fill", descriptionLabelText: "비밀번호", textFieldPlaceholder: "비밀번호를 입력해 주세요", validationText: "8~20자 이내 영문자, 숫자, 특수문자의 조합")
        field.textField.isSecureTextEntry = true
        field.textField.textContentType = .newPassword
        return field
    }()
    private lazy var confirmPasswordField: CustomLabelTextFieldView = {
        let field = CustomLabelTextFieldView(descriptionImageIcon: "lock.fill", descriptionLabelText: "비밀번호 재입력", textFieldPlaceholder: "비밀번호를 다시 입력해 주세요", validationText: "다시 확인해 주세요")
        field.textField.isSecureTextEntry = true
        field.textField.textContentType = .newPassword
        return field
    }()
    
    //MARK: - Buttons
    private let signupButton = CustomButton(
        title: "회원가입",
        titleColor: .white,
        backgroundColor: AppColor.purple100!
    ).then {
        $0.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray

        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named:"icon_back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named:"icon_back")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = .white
        
        self.navigationItem.titleView = titleView
        
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupUI() {
        titleView.addSubview(titleLabel)
        [emailField,passwordField,confirmPasswordField,signupButton].forEach {
            view.addSubview($0)
        }

    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(5)
        }
        emailField.snp.makeConstraints { make in
            make.top.equalTo(Constants.superViewHeight * 0.2)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
        }
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(emailField.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
        }
        confirmPasswordField.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
        }
        signupButton.snp.makeConstraints { make in
            make.top.equalTo(Constants.superViewHeight * 0.8)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
        }
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
    
    private func goToLoginView() {
        let loginViewController = LoginVC()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)  //firstresponder가 전부 사라짐
    }
    
    private func showAlert(title: String = "알림", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
}

