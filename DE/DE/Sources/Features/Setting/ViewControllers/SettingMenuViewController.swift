// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then
import SDWebImage

import CoreModule
import Network

// get api 호출을 할거야
// 캐시 데이터가 있어? -> 그거 써
// 없어? get 해 -> get한 데이터 캐시에 저장

// 일단 캐시 데이터 검증을 해
// 검증 1: 지금 call counter가 모두 0인가
// 검증 2: 데이터 필드 값 중에 nil이 없는가
// 이름, 이미지만 캐시데이터 사용

public final class SettingMenuViewController : UIViewController, UIGestureRecognizerDelegate {
    
    private let networkService = MemberService()
//    private var memberData: MemberInfoResponse?
    private var profileData: SimpleProfileInfoData?
    
    private var tableView = UITableView()
    let navigationBarManager = NavigationBarManager()
    
    private let settingMenuItems: [SettingMenuModel] = [
        SettingMenuItems.accountInfo,
        SettingMenuItems.wishList,
        SettingMenuItems.ownedWine,
        SettingMenuItems.notice,
        SettingMenuItems.appInfo,
        SettingMenuItems.inquiry
    ]

    public let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "profilePlaceholder")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 50
        $0.clipsToBounds = true
    }
    
    public let nameLabel = UILabel().then {
        $0.text = "드링키지"
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 16)
        $0.textAlignment = .center
        $0.textColor = AppColor.black
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        setupUI()
        setupTableView()
        setupNavigationBar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        DispatchQueue.main.async {
            self.CheckCacheData()
        }
        self.view.addSubview(indicator)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = 50
        tableView.backgroundColor = AppColor.bgGray
        tableView.register(SettingMenuViewCell.self, forCellReuseIdentifier: SettingMenuViewCell.identifier)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(DynamicPadding.dynamicValue(16.0))
            make.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24.0))
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    /// UI에 사용할 데이터 불러오기(캐시 or 서버)
    private func CheckCacheData() {
//        print("캐시데이터 체크하려고 들어옴")
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
            print("⚠️ userId가 UserDefaults에 없습니다.")
            return
        }
        
        Task {
            do {
                if try await isCacheDataValid(for: userId) {
//                    print("✅ 캐시 데이터 사용 가능")
                    await useCacheData(for: userId)
                } else {
//                    print("⚠️ 캐시 데이터 유효하지 않음, 서버에서 불러오기")
                    await fetchMemberInfo()
                }
            } catch {
                print("⚠️ 캐시 데이터 검증 중 오류 발생: \(error.localizedDescription)")
                await fetchMemberInfo() // ❗️ 에러 발생 시에도 서버 데이터 호출
            }
        }
    }
    
    private func isCacheDataValid(for userId: Int) async throws -> Bool {
        do {
            let isCallCountZero = try await APICallCounterManager.shared.isCallCountZero(for: userId, controllerName: .member)
            
            // 이름, 이미지만 검증
            let hasNilFields = try await PersonalDataManager.shared.checkPersonalDataTwoPropertyHasNil(for: userId)
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
            if let userName = data.userName, let imageURL = data.userImageURL {
                self.profileData = SimpleProfileInfoData(name: userName, imageURL: imageURL, uniqueUserId: userId)
                setUserData(userName: userName, imageURL: imageURL)
            } else {
                print("⚠️ 캐시 데이터에 필요한 정보가 없습니다.")
            }
        } catch {
            print("⚠️ 캐시 데이터 가져오기 실패: \(error)")
        }
    }

    private func fetchMemberInfo() async {
        self.view.showBlockingView()
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
            print("⚠️ userId가 UserDefaults에 없습니다.")
            return
        }
        
        do {
            let data = try await networkService.fetchUserInfoAsync()
            
            let safeImageUrl = data.imageUrl ?? "https://placehold.co/400x400"
            
            self.profileData = SimpleProfileInfoData(name: data.username, imageURL: safeImageUrl, uniqueUserId: userId)
            
            let userData = MemberInfoResponse(imageUrl: safeImageUrl, username: data.username, email: data.email, city: data.city, authType: data.authType, adult: data.adult)
            
            self.setUserData(userName: data.username, imageURL: safeImageUrl)
//            print("✅ 서버 데이터 성공적으로 가져옴: \(data.username)")
            await saveUserInfo(data: userData)
            
        } catch {
            print("❌ 서버에서 사용자 정보를 가져오지 못함: \(error.localizedDescription)")
            self.view.hideBlockingView()
        }
    }
        
    /// UI update
    func setUserData(userName: String, imageURL: String) {
        let profileImgURL = URL(string: imageURL)
        self.profileImageView.sd_setImage(with: profileImgURL, placeholderImage: UIImage(named: "profilePlaceholder"))
        self.nameLabel.text = "\(userName) 님"
        self.view.hideBlockingView()
    }
    
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

//            print("✅ 사용자 정보가 성공적으로 캐시에 저장되었습니다.")
        } catch {
            print("❌ 사용자 정보 저장 실패: \(error.localizedDescription)")
        }
    }
    
    // MARK: - UI Setup
    private func setupNavigationBar() {
        navigationBarManager.setTitle(to: navigationItem, title: "마이페이지", textColor: AppColor.black!)
    }
    
    private func setupUI(){
        [profileImageView, nameLabel].forEach {
            view.addSubview($0)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
    }
    
}

extension SettingMenuViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingMenuItems.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingMenuViewCell.identifier, for: indexPath) as? SettingMenuViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configure(name: settingMenuItems[indexPath.row].name)
        
        return cell
    }
}

extension SettingMenuViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = settingMenuItems[indexPath.row]
        let vc = selectedItem.viewControllerType.init() // 해당 뷰컨트롤러 생성
        navigationController?.pushViewController(vc, animated: true)
    }
}
