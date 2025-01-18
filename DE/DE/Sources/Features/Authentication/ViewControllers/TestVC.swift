// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SwiftUI

import SnapKit

import CoreModule
import Network

public class PalateViewModel: ObservableObject {
    @Published var stats: [RadarData] = [RadarData(label: "당도", value: 0.2), RadarData(label: "알코올", value: 1.0), RadarData(label: "타닌", value: 0.2), RadarData(label: "바디", value: 0.6), RadarData(label: "산도" , value: 0.8)]
}

public class TestVC: UIViewController {
    
    let networkService = AuthService()
    
    // MARK: - UI Elements
    
    var viewModel = PalateViewModel()
    lazy var palateChart = PalateChartView(viewModel: viewModel)
    lazy var hostingController: UIHostingController<PalateChartView> = {
        return UIHostingController(rootView: palateChart)
    }()
    
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
        addChild(hostingController)
        view.addSubview(hostingController.view)
//        view.addSubview(sampleButton)
        
//        // Layout using Auto Layout
//        sampleLabel.translatesAutoresizingMaskIntoConstraints = false
//        sampleButton.translatesAutoresizingMaskIntoConstraints = false
//        
        hostingController.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.superViewHeight * 0.1)
//            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    
    // MARK: - Actions
    @objc private func didTapSampleButton() {
        sampleLabel.text = "유저 이름 세팅하기"
        sampleLabel.textColor = .systemRed
        print("navigationController: \(self.navigationController)")
        
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
            do {
                try await PersonalDataManager.shared.createPersonalData(for: userId)
            } catch {
                print(error)
            }
            
            // UI 전환
            await MainActor.run {
                let homeTabBarController = MainTabBarController()
                homeTabBarController.userName = "tempName"
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let window = windowScene.windows.first {
                    window.rootViewController = homeTabBarController
                    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
                }
            }
        }
        
        
//        let data = networkService.makeUserInfoDTO(name: "도연이다", isNewBie: false, monthPrice: 100000, wineSort: ["레드"], wineArea: ["호주", "프랑스"], region: "서울시 마포구")
        
//        networkService.sendMemberInfo(data: data) { [weak self] result in
//            guard let self = self else { return }
//            
//            switch result {
//            case .success(_):
//                sampleLabel.text = "데이터 전송 성공!"
//                Task {
//                    let userId: Int
//                    if let userIdString = SelectLoginTypeVC.keychain.get("userId"),
//                       let keychainUserId = Int(userIdString) {
//                        userId = keychainUserId
//                    } else if UserDefaults.standard.integer(forKey: "userId") != 0 {
//                        userId = UserDefaults.standard.integer(forKey: "userId")
//                    } else {
//                        print("❌ userId가 존재하지 않습니다.")
//                        return
//                    }
//                    
//                    // 유저 이름 업데이트 - 취향찾기 api 쏘고 나서 Success일떄 처리
//                    await UserDataManager.shared.updateUserName(userId: userId, userName: data.name)
//                    
//                    // UI 전환
//                    await MainActor.run {
//                        let homeTabBarController = MainTabBarController()
//                        homeTabBarController.userName = data.name
//                        
//                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                           let window = windowScene.windows.first {
//                            window.rootViewController = homeTabBarController
//                            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
//                        }
//                    }
//                }
//                
//            case .failure(let error):
//                print("\(error)")
//                sampleLabel.text = "데이터 전송 실패!"
//            }
//        }
        
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
