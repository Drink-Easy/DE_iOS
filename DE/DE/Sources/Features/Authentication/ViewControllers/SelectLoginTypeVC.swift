// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import SwiftyToaster

import KeychainSwift
import KakaoSDKUser
import AuthenticationServices

import Network
import CoreModule

public class SelectLoginTypeVC: UIViewController {
    
    public static let keychain = KeychainSwift()
    lazy var kakaoAuthVM: KakaoAuthVM = KakaoAuthVM()
    let networkService = AuthService()
    
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
        button.setTitle("   애플로 시작하기", for: .normal)
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
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppColor.bgGray
        setupUI()
        setupConstraints()
        joinStackView.setJoinButtonAction(target: self, action: #selector(joinButtonTapped))
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
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
            make.height.equalTo(60)
        }
        appleButton.snp.makeConstraints { make in
            make.top.equalTo(kakaoButton.snp.bottom).offset(10)
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(appleButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
        }
        joinStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview() // 수평 가운데 정렬
            make.bottom.equalToSuperview().offset(-50) // 하단에서 위로 50pt
        }
    }

    @objc func kakaoButtonTapped(_ sender: UIButton) {
        self.kakaoAuthVM.kakaoLogin { success in
            if success {
                UserApi.shared.me { (user, error) in
                    if let error = error {
                        print("에러 발생: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            Toaster.shared.makeToast("사용자 정보 가져오기 실패")
                        }
                        return
                    }
                    
                    guard let userID = user?.id else {
                        print("user id가 nil입니다.")
                        return
                    }
                    guard let userEmail = user?.kakaoAccount?.email else {
                        print("userEmail가 nil입니다.")
                        return
                    }
                    let userIDString = String(userID)
                    
                    let kakaoDTO = self.networkService.makeKakaoDTO(username: userIDString, email: userEmail)
                    self.networkService.kakaoLogin(data: kakaoDTO) { [weak self] result in
                        guard let self = self else { return }
                        
                        switch result {
                        case .success(let response):
                            //TODO: 다음 뷰 설정
                            print("카카오 로그인 성공")
                        case .failure(let error):
                            print(error)
                        }
                    }
                }
            } else {
                print("카카오 회원가입 실패")
            }
        }
    }
    
    @objc private func appleButtonTapped() {
        print("애플 버튼 눌림")
    }
    
    @objc private func loginButtonTapped() {
        let loginViewController = LoginVC()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    @objc private func joinButtonTapped() {
        let joinViewController = SignUpVC()
        navigationController?.pushViewController(joinViewController, animated: true)
    }
    
    private func goToNextView() {
//        if LoginVC.isFirstLogin {
//            let enterTasteTestViewController = TestVC()
//            navigationController?.pushViewController(enterTasteTestViewController, animated: true)
//        } else {
//            let homeViewController = TestVC()
//            navigationController?.pushViewController(homeViewController, animated: true)
//        }
        
    }
    
}
