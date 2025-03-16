// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import StoreKit

import SnapKit
import Then
import SDWebImage

import CoreModule
import Network

enum AppInfoSection: String {
    case service = "서비스 이용약관"
    case privacy = "개인정보 처리방침"
    case location = "위치정보 이용약관"
    case openSource = "오픈소스 라이브러리"
    case copyright = "저작권 법적 고지"
}

class AppInfoViewController : UIViewController, FirebaseTrackable {
    var screenName: String = Tracking.VC.appInfoVC
    
    let navigationBarManager = NavigationBarManager()
    private var memberData: MemberInfoResponse?
    
    private lazy var appVersion: String = {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }()
    
    private var tableView = UITableView()
    
    private let appInfoItems: [AppInfoSection] = [
        AppInfoSection.service,
        AppInfoSection.privacy,
        AppInfoSection.openSource,
        AppInfoSection.copyright
    ]
    
    private let instaButton = UIButton().then {
        $0.setImage(UIImage(named: "instagram")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = AppColor.gray70// 원하는 색상 적용
        $0.addTarget(self, action: #selector(openInstagram), for: .touchUpInside)
    }
    lazy var appVersionLabel = UILabel().then {
        $0.text = "버전 정보"
        $0.font = UIFont.ptdRegularFont(ofSize: 12)
        $0.textColor = AppColor.gray70
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        appVersionLabel.text = "Version \(appVersion)"
        setupTableView()
        setupUI()
        setupNavigationBar()
//        requestReview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
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
            make.top.equalTo(view.safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(8.0))
            make.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24.0))
            make.leading.equalToSuperview()
            make.height.equalTo(200)
        }
    }
    
    // MARK: - UI Setup
//    func requestReview() {
//            if let scene = UIApplication.shared.connectedScenes
//                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
//                SKStoreReviewController.requestReview(in: scene)
//            }
//        }
//    func requestReview() {
//            let appID = 6741486172
//            let urlString = "https://apps.apple.com/app/id\(appID)?action=write-review"
//            
//            if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
//                UIApplication.shared.open(url, options: [:], completionHandler: nil)
//            }
//        }
    
    private func setupNavigationBar() {
        navigationBarManager.setTitle(to: navigationItem, title: "앱 정보", textColor: AppColor.black!)
        navigationBarManager.addBackButton(to: navigationItem, target: self, action: #selector(backButtonTapped))
    }
    
    private func setupUI(){
        view.addSubview(instaButton)
        view.addSubview(appVersionLabel)
        instaButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.size.equalTo(24)
        }
        appVersionLabel.snp.makeConstraints { make in
            make.top.equalTo(instaButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func openInstagram() {
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.instaBtnTapped, fileName: #file)
        if let url = URL(string: "https://www.instagram.com/drinki.g") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension AppInfoViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appInfoItems.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingMenuViewCell.identifier, for: indexPath) as? SettingMenuViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.configure(name: appInfoItems[indexPath.row].rawValue)

        return cell
    }
}

extension AppInfoViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        logCellClick(screenName: screenName, indexPath: indexPath, cellName: Tracking.CellEvent.settingMenuCellTapped, fileName: #file, cellID: SettingMenuViewCell.identifier)
        DispatchQueue.main.async {
            self.view.showBlockingView()
        }
        let selectedItem = appInfoItems[indexPath.row] // 선택된 항목의 이름
        var content: String
        
        // 선택된 항목에 따라 다른 내용 설정
        switch selectedItem {
        case .service:
            content = Constants.Policy.service
        case .privacy:
            content = Constants.Policy.privacy
        case .location:
            content = Constants.Policy.location
        case .openSource:
            content = Constants.Policy.openSource
        case .copyright:
            content = Constants.Policy.copyright
//        default:
//            content = "정보를 찾을 수 없습니다."
        }
        DispatchQueue.main.async {
            self.view.hideBlockingView()
        }
        
        let detailVC = DetailInfoVC(title: selectedItem.rawValue, content: content)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
