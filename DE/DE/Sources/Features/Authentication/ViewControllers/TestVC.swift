// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import HomeModule
import CoreModule
import Network

public class TestVC: UIViewController {
    
    let networkService = AuthService()
    
    // MARK: - UI Elements
    private lazy var sampleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Click Me", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(didTapSampleButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var sampleLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, World!"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    // MARK: - Lifecycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(sampleLabel)
        view.addSubview(sampleButton)
        
        // Layout using Auto Layout
        sampleLabel.translatesAutoresizingMaskIntoConstraints = false
        sampleButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sampleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sampleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            
            sampleButton.topAnchor.constraint(equalTo: sampleLabel.bottomAnchor, constant: 20),
            sampleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sampleButton.widthAnchor.constraint(equalToConstant: 120),
            sampleButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    
    // MARK: - Actions
    @objc private func didTapSampleButton() {
        sampleLabel.text = "취향찾기 더미데이터 전송하기"
        sampleLabel.textColor = .systemRed
        print("navigationController: \(self.navigationController)")
        
        let data = networkService.makeUserInfoDTO(name: "도연이다", isNewBie: false, monthPrice: 100000, wineSort: ["레드"], wineArea: ["호주", "프랑스"], region: "서울시 마포구")
        
        networkService.sendMemberInfo(data: data) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                sampleLabel.text = "데이터 전송 성공!"
                Task {
                    let userId: Int
                    if let userIdString = SelectLoginTypeVC.keychain.get("userId"),
                       let keychainUserId = Int(userIdString) {
                        userId = keychainUserId
                    } else if UserDefaults.standard.integer(forKey: "userId") != 0 {
                        userId = UserDefaults.standard.integer(forKey: "userId")
                    } else {
                        print("❌ userId가 존재하지 않습니다.")
                        return
                    }
                    
                    // 유저 이름 업데이트 - 취향찾기 api 쏘고 나서 Success일떄 처리
                    await UserDataManager.shared.updateUserName(userId: userId, userName: data.name)
                    
                    // UI 전환
                    await MainActor.run {
                        let homeTabBarController = MainTabBarController()
                        homeTabBarController.userName = data.name
                        
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first {
                            window.rootViewController = homeTabBarController
                            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
                        }
                    }
                }
                
            case .failure(let error):
                print("\(error)")
                sampleLabel.text = "데이터 전송 실패!"
            }
        }
        
//        networkService.logout { [weak self] result in
//            guard let self = self else { return }
//            
//            switch result {
//            case .success:
//                sampleLabel.text = "logout!"
//                sampleLabel.textColor = .systemRed
////                let basicVC = SplashVC()
////                basicVC.modalPresentationStyle = .fullScreen
////                present(basicVC, animated: true)
//            case .failure(let error):
//                sampleLabel.text = "로그아웃 실패!"
//            }
//        }
    }
}
