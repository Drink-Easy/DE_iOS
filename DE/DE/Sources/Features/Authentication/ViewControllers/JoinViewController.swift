//
//  JoinViewController.swift
//  Drink-EG
//
//  Created by 이현주 on 7/30/24.
//

import UIKit
import SnapKit
import Moya
import SwiftyToaster

class JoinViewController: UIViewController, UITextFieldDelegate {
    let provider = MoyaProvider<LoginAPI>()
    public var userID : String?
    public var userPW : String?
    var joinDTO : JoinNLoginRequest?

    let joinButton = UIButton(type: .system)
    let loginButton = UIButton(type: .system)
    
    let idTextField = UITextField()
    let pwTextField = UITextField()
    let pwAgainTextField = UITextField()
    
    private let alreadyLabel: UILabel = {
        let l = UILabel()
        l.text = "이미 계정이 있으신가요?"
        l.textColor = UIColor(hex: "#B7B7B7")
        l.font = UIFont.boldSystemFont(ofSize: 14)
        
        return l
    }()
    
    private let idLabel: UILabel = {
        let id = UILabel()
        id.text = "아이디"
        id.textColor = UIColor.white
        id.font = UIFont.boldSystemFont(ofSize: 15)
        
        return id
    }()
    
    private let pwLabel: UILabel = {
        let pw = UILabel()
        pw.text = "비밀번호"
        pw.textColor = UIColor.white
        pw.font = UIFont.boldSystemFont(ofSize: 15)
        
        return pw
    }()
    
    private let pwAgainLabel: UILabel = {
        let pwA = UILabel()
        pwA.text = "비밀번호 재입력"
        pwA.textColor = UIColor.white
        pwA.font = UIFont.boldSystemFont(ofSize: 15)
        
        return pwA
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named:"icon_back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named:"icon_back")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "가입하기"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
                
        let titleView = UIView()
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(5)
        }
        
        self.navigationItem.titleView = titleView

        view.backgroundColor = .black
        
        idTextField.delegate = self
        pwTextField.delegate = self
        pwAgainTextField.delegate = self
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupUI() {
        configureJoinButton()
        configureLoginButton()
        configureIdTextField()
        configurePwTextField()
        configurePwAgainTextField()
        
        view.addSubview(idLabel)
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(49)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(43)
        }
        
        view.addSubview(idTextField)
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(33)
            make.height.equalTo(60)
        }
        
        view.addSubview(pwLabel)
        pwLabel.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(20)
            make.leading.equalTo(idLabel)
        }

        view.addSubview(pwTextField)
        pwTextField.snp.makeConstraints { make in
            make.top.equalTo(pwLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(idTextField)
            make.height.equalTo(idTextField)
        }

        view.addSubview(pwAgainLabel)
        pwAgainLabel.snp.makeConstraints { make in
            make.top.equalTo(pwTextField.snp.bottom).offset(20)
            make.leading.equalTo(pwLabel)
        }
        
        view.addSubview(pwAgainTextField)
        pwAgainTextField.snp.makeConstraints { make in
            make.top.equalTo(pwAgainLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(pwTextField)
            make.height.equalTo(pwTextField)
        }

        view.addSubview(joinButton)
        joinButton.snp.makeConstraints { make in
            make.top.equalTo(pwAgainTextField.snp.bottom).offset(32)
            make.leading.trailing.equalTo(pwAgainTextField)
            make.height.equalTo(pwAgainTextField)
        }
        
        let loginStackView = UIStackView(arrangedSubviews: [alreadyLabel, loginButton])
        loginStackView.axis = .horizontal
        loginStackView.distribution = .fillProportionally
        loginStackView.spacing = 6
        
        view.addSubview(loginStackView)
        loginStackView.snp.makeConstraints { make in
//            make.top.equalTo(joinButton.snp.bottom).offset(227)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.greaterThanOrEqualTo(180)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(25)
        }

    }
    
    private func configureJoinButton() {
        joinButton.setTitle("회원가입", for: .normal)
        joinButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        joinButton.setTitleColor(.white, for: .normal)
        joinButton.contentHorizontalAlignment = .center
        
        joinButton.backgroundColor = UIColor(hex: "#FF6F62")
        joinButton.layer.cornerRadius = 16
        joinButton.layer.borderWidth = 0
        joinButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
    }
    
    @objc private func joinButtonTapped() {
        assignUserData()
        callJoinAPI { [weak self] isSuccess in
            if isSuccess {
                self?.goToLoginView()
            } else {
                print("회원가입 실패")
                Toaster.shared.makeToast("400 Bad Request: Failed to Register", .short)
            }
        }
    }
    
    private func configureLoginButton() {
        loginButton.setTitle("로그인", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        loginButton.setTitleColor(UIColor(hex: "#FF6F62"), for: .normal)
        loginButton.contentHorizontalAlignment = .center
        
        loginButton.backgroundColor = .clear
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func loginButtonTapped() {
        goToLoginView()
    }
    
    private func goToLoginView() {
        let loginViewController = LoginViewController()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    private func configureIdTextField() {
        idTextField.tag = 1
        idTextField.attributedPlaceholder = NSAttributedString(string: "아이디를 입력해 주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "#999999")!, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)])
        idTextField.textColor = .white
        idTextField.tintColor = .white
        idTextField.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.26, alpha: 0.5)
        idTextField.layer.cornerRadius = 16
        idTextField.layer.borderWidth = 2
        idTextField.layer.borderColor = UIColor.white.cgColor.copy(alpha: 0.1)
        idTextField.setIdIcon(UIImage(named: "icon_person")!)
        idTextField.returnKeyType = .done
        idTextField.clearButtonMode = .always
    }
    
    private func configurePwTextField() {
        pwTextField.tag = 2
        pwTextField.attributedPlaceholder = NSAttributedString(string: "비밀번호를 입력해 주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "#999999")!, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)])
        pwTextField.textColor = .white
        pwTextField.tintColor = .white
        pwTextField.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.26, alpha: 0.5)
        pwTextField.layer.cornerRadius = 16
        pwTextField.layer.borderWidth = 2
        pwTextField.layer.borderColor = UIColor.white.cgColor.copy(alpha: 0.1)
        pwTextField.setPwIcon(UIImage(named: "icon_lock")!)
        pwTextField.returnKeyType = .done
        pwTextField.textContentType = .password
        pwTextField.isSecureTextEntry = true
        pwTextField.textContentType = .newPassword
        pwTextField.clearButtonMode = .always
    }
    
    private func configurePwAgainTextField() {
        pwAgainTextField.tag = 3
        pwAgainTextField.attributedPlaceholder = NSAttributedString(string: "비밀번호를 한번 더 입력해 주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor(hex: "#999999")!, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)])
        pwAgainTextField.textColor = .white
        pwAgainTextField.tintColor = .white
        pwAgainTextField.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.26, alpha: 0.5)
        pwAgainTextField.layer.cornerRadius = 16
        pwAgainTextField.layer.borderWidth = 2
        pwAgainTextField.layer.borderColor = UIColor.white.cgColor.copy(alpha: 0.1)
        pwAgainTextField.setPwIcon(UIImage(named: "icon_lock")!)
        pwAgainTextField.returnKeyType = .done
        pwAgainTextField.textContentType = .password
        pwAgainTextField.isSecureTextEntry = true
        pwAgainTextField.textContentType = .newPassword
        pwAgainTextField.clearButtonMode = .always
    }
    
    // UITextFieldDelegate 메서드
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        // 텍스트 필드가 선택되었을 때 배경색 변경
        textField.backgroundColor = UIColor(hue: 0.0111, saturation: 0.61, brightness: 1, alpha: 0.2)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(hex: "#FF6F62")?.cgColor
        if textField.tag == 1 {
            textField.setIdIcon(UIImage(named: "icon_person_fill")!)
        }
        else if textField.tag == 2 || textField.tag == 3 {
            textField.setPwIcon(UIImage(named: "icon_lock_fill")!)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // 텍스트 필드가 선택 해제되었을 때 배경색 원래대로
        textField.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.26, alpha: 0.5)
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.white.cgColor.copy(alpha: 0.1)
        if textField.tag == 1 {
            textField.setIdIcon(UIImage(named: "icon_person")!)
        }
        else if textField.tag == 2 || textField.tag == 3 {
            textField.setPwIcon(UIImage(named: "icon_lock")!)
        }
//        self.userID = self.idTextField.text
//        self.userPW = self.pwTextField.text
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.idTextField {
            if let id = self.idTextField.text {
                self.userID = id
            }
            self.pwTextField.becomeFirstResponder()
        } else if textField == self.pwTextField {
            self.pwAgainTextField.becomeFirstResponder()
        } else if textField == self.pwAgainTextField {
            if let rePW = self.pwAgainTextField.text {
//                guard pw == rePW else {
//                    // toast message 띄우기
//                }
            }
            self.pwAgainTextField.resignFirstResponder()
        }
        return true
    }
    
    private func assignUserData() {
        self.userID = self.idTextField.text
        self.userPW = self.pwTextField.text
        self.joinDTO = JoinNLoginRequest(username: self.userID ?? "", password: self.userPW ?? "")
    }
    
    // 배경 클릭시 키보드 내림  ==> view 에 터치가 들어오면 에디팅모드를 끝냄.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)  //firstresponder가 전부 사라짐
    }
    
    private func callJoinAPI(completion: @escaping (Bool) -> Void) {
        if let data = self.joinDTO {
            provider.request(.postRegister(data: data)) { result in
                switch result {
                case .success(let response):
                    do {
                        let data = try response.map(APIResponseString.self)
//                        print("User Created: \(data)")
                        completion(data.isSuccess)
                    } catch {
                        print("Failed to map data: \(error)")
                        completion(false)
                    }
                case .failure(let error):
                    print("Request failed: \(error)")
                    completion(false)
                }
            }
        } else {
            print("User Data가 없습니다.")
            completion(false)
        }
    }
}

