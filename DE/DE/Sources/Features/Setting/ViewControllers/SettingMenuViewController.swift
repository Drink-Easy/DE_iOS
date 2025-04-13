// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then
import SDWebImage

import CoreModule
import Network

public final class SettingMenuViewController : UIViewController, UIGestureRecognizerDelegate, FirebaseTrackable {
    public var screenName: String = Tracking.VC.settingMainVC
    
    private let networkService = MemberService()
    private let errorHandler = NetworkErrorHandler()
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
        view.backgroundColor = AppColor.background
        setupUI()
        setupTableView()
        setupNavigationBar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(indicator)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        fetchMemberInfo()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = 50
        tableView.backgroundColor = AppColor.background
        tableView.register(SettingMenuViewCell.self, forCellReuseIdentifier: SettingMenuViewCell.identifier)
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(DynamicPadding.dynamicValue(16.0))
            make.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24.0))
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func fetchMemberInfo() {
        self.view.showBlockingView()
        Task {
            do {
                let data = try await networkService.fetchUserInfoAsync()
                
                let safeImageUrl = data.imageUrl ?? "https://placehold.co/400x400"
                
                self.profileData = SimpleProfileInfoData(name: data.username, imageURL: safeImageUrl)
                
                self.setUserData(userName: data.username, imageURL: safeImageUrl)
            } catch {
                self.view.hideBlockingView()
                errorHandler.handleNetworkError(error, in: self)
            }
        }
    }
        
    /// UI update
    func setUserData(userName: String, imageURL: String) {
        DispatchQueue.main.async {
            let profileImgURL = URL(string: imageURL)
            self.profileImageView.sd_setImage(with: profileImgURL, placeholderImage: UIImage(named: "profilePlaceholder"))
            self.nameLabel.text = "\(userName) 님"
            self.view.hideBlockingView()
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
        logCellClick(screenName: screenName, indexPath: indexPath, cellName: Tracking.CellEvent.settingMenuCellTapped, fileName: #file, cellID: SettingMenuViewCell.identifier)
        let selectedItem = settingMenuItems[indexPath.row]
        let vc = selectedItem.viewControllerType.init() // 해당 뷰컨트롤러 생성
        navigationController?.pushViewController(vc, animated: true)
    }
}
