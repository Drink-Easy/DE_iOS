// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import AuthenticationServices
import Moya
import SwiftyToaster
import CoreModule
import Then

public class SelectLoginViewController: UIViewController {
    
    lazy var kakaoAuthVM: KakaoAuthVM = KakaoAuthVM()
    
    private let imageView = UIImageView().then {
        $0.image = UIImage(named: "logo")
    }
    
    let kakaoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#FEE500")
        button.setTitle("   카카오로 시작하기", for: .normal)
        button.setTitleColor(UIColor(hex: "#191919"), for: .normal)
        //        button.titleLabel?.font = UIFont.ptdSemiBoldFont(ofSize: 22)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(kakaoButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let appleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: "#FEE500")
        button.setTitle("   카카오로 시작하기", for: .normal)
        button.setTitleColor(UIColor(hex: "#191919"), for: .normal)
        //        button.titleLabel?.font = UIFont.ptdSemiBoldFont(ofSize: 22)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(appleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    private let loginButton = CustomButton(
        title: "로그인",
        titleColor: .white,
        backgroundColor: AppColor.purple100!
    ).then {
        $0.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    private let joinStackView = JoinStackView()
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        [imageView,kakaoButton,appleButton,loginButton,joinStackView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(Constants.superViewHeight * 0.4)
            make.width.lessThanOrEqualTo(Constants.superViewWidth * 0.6)
        }
        kakaoButton.snp.makeConstraints { make in
            make.top.equalTo(Constants.superViewHeight * 0.6)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(60)
        }
        appleButton.snp.makeConstraints { make in
            make.top.equalTo(kakaoButton.snp.bottom).offset(10)
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(appleButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        joinStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview() // 수평 가운데 정렬
            make.bottom.equalToSuperview().offset(-50) // 하단에서 위로 50pt
        }
    }
    
    @objc private func kakaoButtonTapped() {
        print("카카오 버튼 눌림")
    }
    
    @objc private func appleButtonTapped() {
        print("애플 버튼 눌림")
    }
    
    @objc private func loginButtonTapped() {
        let loginViewController = LoginViewController()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    @objc private func joinButtonTapped() {
        let joinViewController = JoinViewController()
        navigationController?.pushViewController(joinViewController, animated: true)
    }
    
    private func goToNextView() {
        if LoginViewController.isFirstLogin {
            let enterTasteTestViewController = TestVC()
            navigationController?.pushViewController(enterTasteTestViewController, animated: true)
        } else {
            let homeViewController = TestVC()
            navigationController?.pushViewController(homeViewController, animated: true)
        }
        
    }
    
}
