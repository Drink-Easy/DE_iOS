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
        Task {
            CheckCacheData()
        }
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
        navigationBarManager.addLeftRightButtons(
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
        authService.logout() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                if userProfile?.authType == "kakao" {
                    self.kakaoAuthVM.kakaoLogout()
                    Toaster.shared.makeToast("로그아웃")
                } else {
                    Toaster.shared.makeToast("로그아웃")
                }
                self.clearForLogout()
                Task {
                    self.showSplashScreen()
                }
            case .failure(let error):
                print(error)
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
        memberService.deleteUser() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                print("회원탈퇴 완료")
                switch userProfile?.authType.lowercased() { // 무조건 소문자 처리
                    case "kakao" :
                        self.kakaoAuthVM.unlinkKakaoAccount { isSuccess in
                            if isSuccess {
                                print("✅ 카카오 계정 연동 해제 성공")
                                Task {
                                    await self.deleteUserInSwiftData() // 로컬 디비에서 유저 정보 삭제 후 splash 화면으로 이동
                                    self.clearForQuit()
                                    self.showSplashScreen()
                                }
                            } else {
                                print("❌ 카카오 계정 연동 해제 실패")
                            }
                        }
                default :
                    Task {
                        await self.deleteUserInSwiftData()
                        self.clearForQuit()
                        self.showSplashScreen()
                    }
                }
                
            case .failure(let error):
                print("회원탈퇴 실패: \(error.localizedDescription)")
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
        UserDefaults.standard.removeObject(forKey: "userId")
        clearCookie()
    }
    
    func clearForQuit() {
        clearCookie()
        ["userId", "isFirst", "AppleIDToken"].forEach {
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
                    print("✅ 캐시 데이터 사용 가능")
                    await useCacheData(for: userId)
                } else {
                    fetchMemberInfo()
                }
            } catch {
                print("⚠️ 캐시 데이터 검증 실패: \(error)")
                fetchMemberInfo()
            }
        }
    }
    
    /// 캐시 데이터 검증
    private func isCacheDataValid(for userId: Int) async throws -> Bool {
        let isCallCountZero = try await APICallCounterManager.shared.isCallCountZero(for: userId, controllerName: .member)
        
        // 전체 유저 프로필 데이터 nil 검증
        let hasNilFields = try await PersonalDataManager.shared.checkPersonalDataHasNil(for: userId)
        return isCallCountZero && !hasNilFields
    }
    
    /// 캐시 데이터 사용
    private func useCacheData(for userId: Int) async {
        do {
            let data = try await PersonalDataManager.shared.fetchPersonalData(for: userId)
            
            if let username = data.userName, let imageURL = data.userImageURL, let email = data.email, let city = data.userCity, let authType = data.authType, let adult = data.adult {
                self.userProfile = MemberInfoResponse(imageUrl: imageURL, username: username, email: email, city: city, authType: authType, adult: adult)
                self.setUserData(
                    imageURL: imageURL,
                    username: username,
                    email: email,
                    city: city,
                    authType: authType,
                    adult: adult
                )
            } else {
                print("⚠️ 캐시 데이터에 필요한 정보가 없습니다.")
            }
        } catch {
            print("⚠️ 캐시 데이터 가져오기 실패: \(error)")
        }
    }
    
    /// 서버에서 데이터 가져오기
    private func fetchMemberInfo() {
        memberService.fetchUserInfo(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
                    print("⚠️ userId가 UserDefaults에 없습니다.")
                    return
                }
                Task {
                    // 데이터 할당
                    self.userProfile = MemberInfoResponse(imageUrl: data.imageUrl, username: data.username, email: data.email, city: data.city, authType: data.authType, adult: data.adult)
                    self.setUserData(
                        imageURL: data.imageUrl,
                        username: data.username,
                        email: data.email,
                        city: data.city,
                        authType: data.authType,
                        adult: data.adult
                    )
                    // 로컬 캐시 데이터에 저장(덮어쓰기)
                    await self.saveUserInfo(data: MemberInfoResponse(imageUrl: data.imageUrl, username: data.username, email: data.email, city: data.city, authType: data.authType, adult: data.adult))
                    do {
                        // get api -> 모든 call counter 초기화
                        try await APICallCounterManager.shared.resetCallCount(for: userId, controllerName: .member)
                        return
                    } catch {
                        print("⚠️ API 호출 카운트 초기화 실패: \(error)")
                    }
                }
            case .failure(let error ):
                print("Error: \(error)")
            }
        })
    }
    
    /// UI update
    private func setUserData(imageURL: String, username: String, email: String, city: String, authType: String, adult: Bool) {
        // 데이터 처리
        let profileImgURL = URL(string: imageURL)
        self.profileImageView.sd_setImage(with: profileImgURL, placeholderImage: UIImage(named: "profilePlaceholder"))
        accountView.titleLabel.text = "내 정보"
        let adultText = adult ? "인증 완료" : "인증 전"
        accountView.items = [("닉네임", username),
        ("내 동네", city),
        ("이메일", email),
        ("연동상태", authType),
        ("성인인증", adultText)]
    }
    
    /// 새로 받은 데이터 저장
    private func saveUserInfo(data: MemberInfoResponse) async {
        do {
            guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
                print("⚠️ userId가 UserDefaults에 없습니다.")
                return
            }
            try await PersonalDataManager.shared.updatePersonalData(for: userId,
                                                                    userName: data.username,
                                                                    userImageURL: data.imageUrl,
                                                                    userCity: data.city,
                                                                    authType: data.authType,
                                                                    email: data.email,
                                                                    adult: data.adult)
        } catch {
            print(error)
        }
    }
}
