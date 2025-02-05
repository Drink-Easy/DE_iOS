// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule
import Network

import SwiftyToaster

/// 계정 정보 확인 페이지
class AccountInfoViewController: UIViewController {
    
    //MARK: - Variables 
    private let navigationBarManager = NavigationBarManager()
    let memberService = MemberService()
    private let authService = AuthService()
    lazy var kakaoAuthVM: KakaoAuthVM = KakaoAuthVM()
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
        let vc = ProfileEditVC()
        vc.profileImgURL = userProfile?.imageUrl
        vc.originUsername = userProfile?.username
        vc.originUserCity = userProfile?.city
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func logoutButtonTapped() {
        self.view.showBlockingView()
        Task {
            do {
                let result = try await authService.logout()
                if userProfile?.authType == "kakao" {
                    self.kakaoAuthVM.kakaoLogout()
                    Toaster.shared.makeToast(result)
                } else {
                    Toaster.shared.makeToast(result)
                }
                self.clearForLogout()
                
                DispatchQueue.main.async {
                    self.view.hideBlockingView()
                    self.showSplashScreen()
                }
            } catch {
                print(error)
                self.view.hideBlockingView()
            }
        }
    }


    @objc private func deleteButtonTapped() {
        let alert = UIAlertController(
            title: "계정 삭제",
            message: "계정을 정말 삭제하시겠습니까?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
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
                let result = try await memberService.deleteUser()
                
                if userProfile?.authType.lowercased() == "kakao" {
                    if await !self.kakaoAuthVM.unlinkKakaoAccount() {
                        view.hideBlockingView()
                    }
                }
                await self.deleteUserInSwiftData() // 로컬 디비에서 유저 정보 삭제 후 splash 화면으로 이동
                DispatchQueue.main.async {
                    self.clearForQuit()
                    self.view.hideBlockingView()
                    self.showSplashScreen()
                }
            } catch {
                print("회원탈퇴 실패: \(error.localizedDescription)")
                view.hideBlockingView()
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
        guard let cookies = HTTPCookieStorage.shared.cookies else { return }
        
        let targetCookieNames = ["accessToken", "refreshToken"]
        
        for cookie in cookies {
            if targetCookieNames.contains(cookie.name) {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        
        print("✅ 쿠키에 저장된 토큰이 삭제되었습니다.")
    }
    
    private func clearForLogout() {
        SelectLoginTypeVC.keychain.delete("userId")
        SelectLoginTypeVC.keychain.delete("isFirst")
        UserDefaults.standard.removeObject(forKey: "userId")
        clearCookie()
    }

    func clearForQuit() {
        clearCookie()
        // 저장된 아이디도 삭제
        ["userId", "isFirst", "AppleIDToken", "savedUserEmail"].forEach {
            SelectLoginTypeVC.keychain.delete($0)
        }
        UserDefaults.standard.removeObject(forKey: "userId")
    }
    
    //MARK: - SwiftDate Funcs
    
    /// UI에 사용할 데이터 불러오기(캐시 or 서버)
    private func CheckCacheData() {
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
            print("⚠️ userId가 UserDefaults에 없습니다.")
            return
        }
        
        Task {
            do {
                if try await isCacheDataValid(for: userId) {
                    await useCacheData(for: userId)
                } else {
                    await fetchMemberInfo()
                }
            } catch {
                print("⚠️ 캐시 데이터 검증 중 오류 발생: \(error.localizedDescription)")
                await fetchMemberInfo() // ❗️ 에러 발생 시에도 서버 데이터 호출
            }
        }
    }
    
    /// 캐시 데이터 검증
    private func isCacheDataValid(for userId: Int) async throws -> Bool {
        do {
            let isCallCountZero = try await APICallCounterManager.shared.isCallCountZero(for: userId, controllerName: .member)
            
            // 전체 유저 프로필 데이터 nil 검증
            let hasNilFields = try await PersonalDataManager.shared.checkPersonalDataHasNil(for: userId)
            return isCallCountZero && !hasNilFields
        } catch {
            print(error)
            try await APICallCounterManager.shared.createAPIControllerCounter(for: userId, controllerName: .member)
        }
        return false
    }
    
    /// 캐시 데이터 사용
    private func useCacheData(for userId: Int) async {
        do {
            let data = try await PersonalDataManager.shared.fetchPersonalData(for: userId)
            
            guard let username = data.userName,
                  let imageURL = data.userImageURL,
                  let email = data.email,
                  let city = data.userCity,
                  let authType = data.authType,
                  let adult = data.adult else {
                print("⚠️ 여기 사실 들어올 일이 없음. 이미 검증해줘서.")
                return
            }
            
            self.userProfile = MemberInfoResponse(imageUrl: imageURL, username: username, email: email, city: city, authType: authType, adult: adult)
            self.setUserData(imageURL: imageURL, username: username, email: email, city: city, authType: authType, adult: adult)
        } catch {
            print("⚠️ 캐시 데이터 가져오기 실패: \(error.localizedDescription)")
            await fetchMemberInfo()
        }
    }
    
    /// 서버에서 데이터 가져오기
    private func fetchMemberInfo() async {
        do {
            self.view.showBlockingView()
            let data = try await memberService.fetchUserInfoAsync()
            
            let safeImageUrl = data.imageUrl ?? "https://placehold.co/400x400"
            
            self.userProfile = MemberInfoResponse(imageUrl: safeImageUrl, username: data.username, email: data.email, city: data.city, authType: data.authType, adult: data.adult)
            self.setUserData(imageURL: safeImageUrl, username: data.username, email: data.email, city: data.city, authType: data.authType, adult: data.adult)

            await saveUserInfo(data: self.userProfile!)
            self.view.hideBlockingView()
        } catch {
            print("❌ 서버에서 사용자 정보를 가져오지 못함: \(error.localizedDescription)")
            self.view.hideBlockingView()
        }
    }
    
    /// UI update
    private func setUserData(imageURL: String, username: String, email: String, city: String, authType: String, adult: Bool) {
        DispatchQueue.main.async {
            let profileImgURL = URL(string: imageURL)
            self.profileImageView.sd_setImage(with: profileImgURL, placeholderImage: UIImage(named: "profilePlaceholder"))
            self.accountView.titleLabel.text = "내 정보"
            let adultText = adult ? "인증 완료" : "인증 전"
            self.accountView.items = [("닉네임", username),
            ("내 동네", city),
            ("이메일", email),
            ("연동상태", authType)
    //        ("성인인증", adultText)
            ]
        }
    }
    
    /// 새로 받은 데이터 저장
    private func saveUserInfo(data: MemberInfoResponse) async {
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
            print("⚠️ userId가 UserDefaults에 없습니다.")
            return
        }
        
        do {
            try await PersonalDataManager.shared.updatePersonalData(for: userId,
                userName: data.username,
                userImageURL: data.imageUrl,
                userCity: data.city,
                authType: data.authType,
                email: data.email,
                adult: data.adult
            )

            try await APICallCounterManager.shared.createAPIControllerCounter(for: userId, controllerName: .member)
            try await APICallCounterManager.shared.resetCallCount(for: userId, controllerName: .member)
        } catch {
            print("❌ 사용자 정보 저장 실패: \(error.localizedDescription)")
        }
    }
}
