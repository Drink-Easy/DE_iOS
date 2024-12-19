//
//  LoginViewController.swift
//  Drink-EG
//
//  Created by 이현주 on 7/30/24.
//

import UIKit
import SnapKit
import Moya
import SwiftyToaster

class LoginViewController: UIViewController, UITextFieldDelegate {
    public static var isFirstLogin : Bool = true
    
    let provider = MoyaProvider<LoginAPI>()
    public var userID : String?
    public var userPW : String?
    var loginDTO : JoinNLoginRequest?
    
    let loginButton = UIButton(type: .system)
    let joinButton = UIButton(type: .system)
    
    let idStoreButton = UIButton(type: .custom)
    private let checkImage = UIImage(named: "icon_check_fill")
    private let ncheckImage = UIImage(named: "icon_check_nfill")
    
    let idSearchButton = UIButton(type: .system)
    
    let idTextField = UITextField()
    let pwTextField = UITextField()
    
    private let notYetLabel: UILabel = {
        let l = UILabel()
        l.text = "아직 회원이 아니신가요?"
        l.textColor = UIColor(hex: "#B7B7B7")
        l.font = UIFont.boldSystemFont(ofSize: 14)
        
        return l
    }()
    
    private let idStoreLabel: UILabel = {
        let l = UILabel()
        l.text = "아이디 저장"
        l.textColor = UIColor(hex: "#999999")
        l.font = UIFont.systemFont(ofSize: 14)
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named:"icon_back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named:"icon_back")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = .white
        
        let titleLabel = UILabel()
        titleLabel.text = "로그인"
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
        
        setupUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupUI() {
        configureLoginButton()
        configureJoinButton()
        configureIdStoreButton()
        configureIdSearchButton()
        configureIdTextField()
        configurePwTextField()
            
        view.addSubview(idLabel)
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(53)
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
        
        let idStoreStackView = UIStackView(arrangedSubviews: [idStoreButton, idStoreLabel])
        idStoreStackView.axis = .horizontal
        idStoreStackView.distribution = .fillProportionally
        idStoreStackView.spacing = 5
        
        view.addSubview(idStoreStackView)
        idStoreStackView.snp.makeConstraints { make in
            make.top.equalTo(pwTextField.snp.bottom).offset(24)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(43)
        }
        
        view.addSubview(idSearchButton)
        idSearchButton.snp.makeConstraints { make in
            make.top.equalTo(idStoreStackView)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(33)
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(idStoreStackView).offset(71)
            make.leading.trailing.equalTo(pwTextField)
            make.height.equalTo(pwTextField)
        }
        
        let joinStackView = UIStackView(arrangedSubviews: [notYetLabel, joinButton])
        joinStackView.axis = .horizontal
        joinStackView.distribution = .fillProportionally
        joinStackView.spacing = 6
        
        view.addSubview(joinStackView)
        joinStackView.snp.makeConstraints { make in
//            make.top.equalTo(loginButton.snp.bottom).offset(250)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.width.greaterThanOrEqualTo(200)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(25)
        }
    }
    
    private func configureLoginButton() {
        loginButton.setTitle("로그인", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.contentHorizontalAlignment = .center
        
        loginButton.backgroundColor = UIColor(hex: "#FF6F62")
        loginButton.layer.cornerRadius = 16
        loginButton.layer.borderWidth = 0
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func loginButtonTapped() {
        assignUserData()
        callLoginAPI { [weak self] isSuccess in
            if isSuccess {
                if LoginViewController.isFirstLogin {
                    self?.goToNextView()
                } else {
                    self?.goToHomeView()
                }
                
            } else {
                print("로그인 실패")
                Toaster.shared.makeToast("400 Bad Request : Failed to Login", .short)
            }
        }
    }
    
    private func goToNextView() {
        if LoginViewController.isFirstLogin {
            let enterTasteTestViewController = EnterTasteTestViewController()
            navigationController?.pushViewController(enterTasteTestViewController, animated: true)
        } else {
            let homeViewController = HomeViewController()
            navigationController?.pushViewController(homeViewController, animated: true)
        }
        
    }
    
    private func goToHomeView() {
        let homeViewController = MainTabBarViewController()
        navigationController?.pushViewController(homeViewController, animated: true)
    }
    
    private func configureJoinButton() {
        joinButton.setTitle("회원가입", for: .normal)
        joinButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        joinButton.setTitleColor(UIColor(hex: "#FF6F62"), for: .normal)
        joinButton.contentHorizontalAlignment = .center
        
        joinButton.backgroundColor = .clear
        joinButton.addTarget(self, action: #selector(joinButtonTapped), for: .touchUpInside)
    }
    
    @objc private func joinButtonTapped() {
        let joinViewController = JoinViewController()
        navigationController?.pushViewController(joinViewController, animated: true)
    }
    
    private func configureIdStoreButton() {
        idStoreButton.setImage(ncheckImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        idStoreButton.backgroundColor = .clear
        idStoreButton.addTarget(self, action: #selector(idStoreButtonTapped), for: .touchUpInside)
    }
    
    @objc private func idStoreButtonTapped(_ sender: UIButton) {
        // Bool 값 toggle
        sender.isSelected.toggle()
        
        // 버튼이 클릭될 때마다, 버튼 이미지를 변환
        if sender.isSelected {
            sender.setImage(checkImage?.withRenderingMode(.alwaysOriginal), for: .selected)
        } else {
            sender.setImage(ncheckImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    private func configureIdSearchButton() {
        idSearchButton.setTitle("아이디/비밀번호 찾기", for: .normal)
        idSearchButton.setTitleColor(UIColor(hex: "#999999"), for: .normal)
        idSearchButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        idSearchButton.backgroundColor = .clear
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
        else if textField.tag == 2 {
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
        else if textField.tag == 2 {
            textField.setPwIcon(UIImage(named: "icon_lock")!)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.idTextField {
            if let id = self.idTextField.text {
                self.userID = id
            }
            self.pwTextField.becomeFirstResponder()
        } else if textField == self.pwTextField {
            if let pw = self.pwTextField.text {
                self.userPW = pw
            }
            self.pwTextField.resignFirstResponder()
        }
        return true
    }
    
    private func assignUserData() {
        self.userID = self.idTextField.text
        self.userPW = self.pwTextField.text
        self.loginDTO = JoinNLoginRequest(username: self.userID ?? "", password: self.userPW ?? "")
    }
    
    // 배경 클릭시 키보드 내림  ==> view 에 터치가 들어오면 에디팅모드를 끝냄.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)  //firstresponder가 전부 사라짐
    }
    
    private func callLoginAPI(completion: @escaping (Bool) -> Void) {
        if let data = self.loginDTO {
            provider.request(.postLogin(data: data)) { result in
                switch result {
                case .success(let response):
                    if let httpResponse = response.response,
                       let setCookie = httpResponse.allHeaderFields["Set-Cookie"] as? String {
                        let cookies = HTTPCookie.cookies(withResponseHeaderFields: ["Set-Cookie": setCookie], for: httpResponse.url!)
                        
                        for cookie in cookies {
                            HTTPCookieStorage.shared.setCookie(cookie)
                        }
                        do {
                            let data = try response.map(LoginResponse.self)
                            LoginViewController.isFirstLogin = data.isFirst
                        } catch {
                            completion(false)
                        }
                    }
                    completion(true)
                case .failure(let error):
                    print("Request failed: \(error)")
                    completion(false)
                }
            }
        }
    }
}

extension UITextField : UITextFieldDelegate {
    
    private static let idIconTag = 1
    private static let pwIconTag = 2
    
    func setIdIcon(_ image: UIImage) {
        if let iconContainerView = leftView,
           let iconView = iconContainerView.viewWithTag(UITextField.idIconTag) as? UIImageView {
            iconView.image = image
        } else {
            let iconView = UIImageView(frame: CGRect(x: 26, y: -9, width: 16, height: 16))
            iconView.image = image
            iconView.tag = UITextField.idIconTag
            let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 58, height: self.frame.height))
            iconContainerView.addSubview(iconView)
            leftView = iconContainerView
            leftViewMode = .always
        }
    }
    
    func setPwIcon(_ image: UIImage) {
        if let iconContainerView = leftView,
           let iconView = iconContainerView.viewWithTag(UITextField.pwIconTag) as? UIImageView {
            iconView.image = image
        } else {
            let iconView = UIImageView(frame: CGRect(x: 28, y: -10, width: 13.5, height: 18))
            iconView.image = image
            iconView.tag = UITextField.pwIconTag
            let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 58, height: self.frame.height))
            iconContainerView.addSubview(iconView)
            leftView = iconContainerView
            leftViewMode = .always
        }
    }
}

