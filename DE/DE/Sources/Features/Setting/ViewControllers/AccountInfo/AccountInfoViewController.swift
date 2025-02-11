// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule
import Network

import SwiftyToaster

/// 계정 정보 확인 페이지
class AccountInfoViewController: UIViewController, FirebaseTrackable {
    var screenName: String = Tracking.VC.accountInfoVC
    
    //MARK: - Variables 
    private let navigationBarManager = NavigationBarManager()
    let memberService = MemberService()
    private let authService = AuthService()
    lazy var kakaoAuthVM: KakaoAuthVM = KakaoAuthVM()
    private let errorHandler = NetworkErrorHandler()
    
    private var userProfile: MemberInfoResponse?
    
    //MARK: - UI Components
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 60
    }

    private let accountView = SimpleListView()
    
    private let logoutButton = UIButton().then {
        $0.setTitle("로그아웃   |", for: .normal)
        $0.setTitleColor(AppColor.gray50, for: .normal)
        $0.titleLabel?.font = UIFont.ptdMediumFont(ofSize: 11)
    }
    
    private let deleteButton = UIButton().then {
        $0.setTitle("탈퇴하기", for: .normal)
        $0.setTitleColor(AppColor.gray50, for: .normal)
        $0.titleLabel?.font = UIFont.ptdMediumFont(ofSize: 11)
    }
    
    //MARK: - View LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        CheckCacheData()
        self.view.addSubview(indicator)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        setupNavigationBar()
        setupUI()
        setupAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
    }
    
    //MARK: - UI Funcs
    
    private func setupNavigationBar() {
        navigationBarManager.setTitle(to: navigationItem, title: "내 정보", textColor: AppColor.black!)
        navigationBarManager.addLeftRightButtonsWithWeight(
            to: navigationItem,
            leftIcon: "chevron.left",
            leftAction: #selector(backButtonTapped),
            rightIcon: "pencil",
            rightAction: #selector(goToProfileEditView),
            target: self,
            tintColor: AppColor.gray70 ?? .gray
        )
    }
    
    private func setupAction() {
        logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    private func setupUI() {
        [profileImageView, accountView, logoutButton, deleteButton].forEach {
            view.addSubview($0)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        accountView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-48)
            make.trailing.equalTo(view.snp.centerX)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-48)
            make.centerY.equalTo(logoutButton)
            make.leading.equalTo(view.snp.centerX).offset(8)
        }
    }
    
    //MARK: - Objc Funcs
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func goToProfileEditView() {
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.editProfileBtnTapped, fileName: #file)
        let vc = ProfileEditVC()
        vc.profileImgURL = userProfile?.imageUrl
        vc.originUsername = userProfile?.username
        vc.originUserCity = userProfile?.city
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func logoutButtonTapped() {
        clearCookie()
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.logoutBtnTapped, fileName: #file)
        self.view.showBlockingView()
        Task {
            do {
                let result = try await authService.logout()
                if userProfile?.authType == "kakao" {
                    self.kakaoAuthVM.kakaoLogout()
                    showToastMessage(message: result, yPosition: view.frame.height * 0.7)
                } else {
                    showToastMessage(message: result, yPosition: view.frame.height * 0.7)
                }
                self.clearForLogout()
                
                DispatchQueue.main.async {
                    self.view.hideBlockingView()
                    self.showSplashScreen()
                }
            } catch let error as NetworkError {
                self.view.hideBlockingView()
                print(error.errorDescription!)
                errorHandler.handleNetworkError(error, in: self)
            } catch {
                self.view.hideBlockingView()
                errorHandler.handleNetworkError(error, in: self)
            }
        }
    }
    

    @objc private func deleteButtonTapped() {
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.quitBtnTapped, fileName: #file)
        let alert = UIAlertController(
            title: "계정 삭제",
            message: "계정을 정말 삭제하시겠습니까?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in self.logButtonClick(screenName: self.screenName, buttonName: Tracking.ButtonEvent.alertCancelBtnTapped, fileName: #file)}))
        
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
            self?.logButtonClick(screenName: self!.screenName,
                                 buttonName: Tracking.ButtonEvent.alertAcceptBtnTapped,
                           fileName: #file)
            if self?.userProfile?.authType.lowercased() == "apple" { // 애플인 경우에
                self?.reAuthenticateWithApple()
            } else {
                self?.performUserDeletion()
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Funcs
    private func performUserDeletion() {
        view.showBlockingView()
        Task {
            do {
                let _ = try await memberService.deleteUser()
                
                if userProfile?.authType.lowercased() == "kakao" {
                    if await !self.kakaoAuthVM.unlinkKakaoAccount() {
                        view.hideBlockingView()
                    }
                }
                DispatchQueue.main.async {
                    self.clearForQuit()
                    self.view.hideBlockingView()
                    self.showSplashScreen()
                }
            } catch let error as NetworkError {
                self.view.hideBlockingView()
                print(error.errorDescription!)
                errorHandler.handleNetworkError(error, in: self)
            } catch {
                self.view.hideBlockingView()
                errorHandler.handleNetworkError(error, in: self)
            }
        }
    }
    
    func showSplashScreen() {
        let splashViewController = SplashVC()
        
        // 현재 윈도우 가져오기
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first else {
            print("윈도우를 가져올 수 없습니다.")
            return
        }
        
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = splashViewController
        }, completion: nil)
    }
    
    private func clearCookie() {
        guard let cookies = HTTPCookieStorage.shared.cookies(for: URL(string: API.baseURL)!) else { return }
        
        let targetCookieNames = ["accessToken", "refreshToken"]
        
        for cookie in cookies {
            if targetCookieNames.contains(cookie.name) {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        
        print("✅ 쿠키에 저장된 토큰이 삭제되었습니다.")
    }
    
    private func clearForLogout() {
//        SelectLoginTypeVC.keychain.delete("userId")
        SelectLoginTypeVC.keychain.delete("isFirst")
//        UserDefaults.standard.removeObject(forKey: "userId")
        clearCookie()
    }

    func clearForQuit() {
        clearCookie()
        ["isFirst", "AppleIDToken", "savedUserEmail"].forEach {
            SelectLoginTypeVC.keychain.delete($0)
        }
//        UserDefaults.standard.removeObject(forKey: "userId")
    }
    
    //MARK: - SwiftDate Funcs
    
    /// UI에 사용할 데이터 불러오기(캐시 or 서버)
    private func CheckCacheData() {
        self.view.showBlockingView()
        Task {
            await fetchMemberInfo() // ❗️ 에러 발생 시에도 서버 데이터 호출
            self.view.hideBlockingView()
        }
    }

    /// 서버에서 데이터 가져오기
    private func fetchMemberInfo() async {
        do {
            let data = try await memberService.fetchUserInfoAsync()
            
            let safeImageUrl = data.imageUrl ?? "https://placehold.co/400x400"
            
            self.userProfile = MemberInfoResponse(imageUrl: safeImageUrl, username: data.username, email: data.email, city: data.city, authType: data.authType, adult: data.adult)
            self.setUserData(imageURL: safeImageUrl, username: data.username, email: data.email, city: data.city, authType: data.authType, adult: data.adult)
        }  catch let error as NetworkError {
            self.view.hideBlockingView()
            print(error.errorDescription!)
            errorHandler.handleNetworkError(error, in: self)
        } catch {
            self.view.hideBlockingView()
            errorHandler.handleNetworkError(error, in: self)
        }
    }
    
    private func changeKor(_ authType: String) -> String {
        switch authType.lowercased() {
        case "apple" :
            return "애플"
        case "kakao" :
            return "카카오"
        default:
            return "드링키지"
        }
    }
    
    /// UI update
    private func setUserData(imageURL: String, username: String, email: String, city: String, authType: String, adult: Bool) {
        DispatchQueue.main.async {
            let profileImgURL = URL(string: imageURL)
            self.profileImageView.sd_setImage(with: profileImgURL, placeholderImage: UIImage(named: "profilePlaceholder"))
            self.accountView.titleLabel.text = "내 정보"
//            let adultText = adult ? "인증 완료" : "인증 전"
            self.accountView.items = [("닉네임", username),
                                      ("내 동네", city),
                                      ("이메일", email),
                                      ("연동상태", self.changeKor(authType))
    //        ("성인인증", adultText)
            ]
        }
    }
}
