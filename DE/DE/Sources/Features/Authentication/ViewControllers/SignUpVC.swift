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
    var joinDTO : JoinNLoginRequest?
    
    //MARK: - TextFields
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
        
        // 이거 왜 여기에다가 선언했는지?
        let titleLabel = UILabel()
        titleLabel.text = "가입하기"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
                
        let titleView = UIView()
        
        // TODO : 이런거 함수 분리 반드시!!
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(5)
        }
        
        self.navigationItem.titleView = titleView
        
        setupUI()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupUI() {
        [emailField,passwordField,confirmPasswordField,signupButton].forEach {
            view.addSubview($0)
        }

    }
    
    private func setupConstraints() {
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
        
        networkService.join(data: JoinDTO, completion: <#T##(Result<Void, NetworkError>) -> Void#>)
        
    }

    private func goToLoginView() {
        let loginViewController = LoginVC()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    private func assignUserData() {
        self.joinDTO = JoinNLoginRequest(username: self.userID ?? "", password: self.userPW ?? "")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)  //firstresponder가 전부 사라짐
    }
    
    private func callJoinAPI(completion: @escaping (Bool) -> Void) {
//        if let data = self.joinDTO {
//            provider.request(.postRegister(data: data)) { result in
//                switch result {
//                case .success(let response):
//                    do {
//                        let data = try response.map(APIResponseString.self)
////                        print("User Created: \(data)")
//                        completion(data.isSuccess)
//                    } catch {
//                        print("Failed to map data: \(error)")
//                        completion(false)
//                    }
//                case .failure(let error):
//                    print("Request failed: \(error)")
//                    completion(false)
//                }
//            }
//        } else {
//            print("User Data가 없습니다.")
//            completion(false)
//        }
    }
}

