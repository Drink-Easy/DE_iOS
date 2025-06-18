// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Combine
import SnapKit
import Then
import SwiftyToaster
import KeychainSwift

import Network
import CoreModule
import DesignSystem

import AuthenticationServices
import KakaoSDKUser
import FirebaseAnalytics


public class SelectLoginTypeVC: UIViewController, FirebaseTrackable, UIGestureRecognizerDelegate {
    public var screenName: String = Tracking.VC.selectLoginTypeVC
    
    public static let keychain = KeychainSwift() // 더 앞에서 만들어주자 -> 이동 예정
    let errorHandler = NetworkErrorHandler()
    let networkService = AuthService()
    var appleLoginDto : AppleLoginRequestDTO?
    
    var viewModel: SelectLoginViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let mainView = SelectLoginTypeView()
    
    init(viewModel: SelectLoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    public override func loadView() {
        self.view = mainView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background
        setupActions()
        view.addSubview(indicator)
        
        viewModel.bind()       // ViewModel 입력 바인딩
        bindViewModel()        // ViewModel 출력 바인딩
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
    }
    
    func bindViewModel() {
        viewModel.output
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case let .loading(turnOn):
                    turnOn ? self?.view.showBlockingView() : self?.view.hideBlockingView()
                
                case let .failed(error):
                    self?.errorHandler.handleNetworkError(error, in: self!)
                    
                case let .success(isFirst):
                    self?.goToNextView(isFirst)
                default: break
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Setup Methods
    private func setupActions() {
        mainView.kakaoButton.addTarget(self, action: #selector(kakaoButtonTapped), for: .touchUpInside)
        mainView.appleButton.addTarget(self, action: #selector(appleButtonTapped), for: .touchUpInside)
        mainView.loginButton.addTarget(self, action: #selector(goToLoginVC), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func kakaoButtonTapped() {
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.kakaoBtnTapped, fileName: #file)
        
        // 뷰모델에 카카오 버튼이 눌렸다는 걸 알려주기 -> Input
        viewModel.input.send(.kakaoLogin)
    }
    
    @objc private func appleButtonTapped() {
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.appleBtnTapped, fileName: #file)
        
        // 뷰모델에 애플로그인 버튼이 눌렸다는 걸 알려주기 -> input
        startAppleLoginProcess()
    }
    
    @objc private func goToLoginVC() {
        let loginViewController = LoginVC()
        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    func goToNextView(_ isFirstLogin: Bool) {
        if isFirstLogin {
            let enterTasteTestViewController = TermsOfServiceVC()
            navigationController?.pushViewController(enterTasteTestViewController, animated: true)
        } else {
            let homeViewController = MainTabBarController()
            navigationController?.pushViewController(homeViewController, animated: true)
        }
    }
    
}
