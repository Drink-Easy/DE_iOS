// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import StoreKit

import SnapKit
import Then
import SDWebImage

import CoreModule
import Network

class AppInfoViewController : UIViewController, FirebaseTrackable {
    var screenName: String = Tracking.VC.appInfoVC
    
    let navigationBarManager = NavigationBarManager()
    private var memberData: MemberInfoResponse?
    
    private lazy var appVersion: String = {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }()
    
    private var tableView = UITableView()
    
    private let appInfoItems = AppInfoSection.allCases
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        requestReview()
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
        let verticalPadding = DynamicPadding.dynamicValue(8.0)
        let horizontalInset = DynamicPadding.dynamicValue(24.0)
        let rowHeight: CGFloat = 50

        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = rowHeight
        tableView.backgroundColor = AppColor.bgGray
        tableView.register(SettingMenuViewCell.self, forCellReuseIdentifier: SettingMenuViewCell.identifier)

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(verticalPadding)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview().inset(horizontalInset)
            make.height.equalTo(rowHeight * CGFloat(appInfoItems.count))
        }
    }
    
    // MARK: - UI Setup
    func requestReview() {
        if let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    func requestReviewInAppstore() {
        let appID = 6741486172
        let urlString = "https://apps.apple.com/app/id\(appID)?action=write-review"
        
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        } else {
            print("❌ URL 생성 실패: \(urlString)")
        }
    }
    
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
        cell.configure(name: appInfoItems[indexPath.row].title)
        
        return cell
    }
}

extension AppInfoViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        logCellClick(screenName: screenName, indexPath: indexPath, cellName: Tracking.CellEvent.settingMenuCellTapped, fileName: #file, cellID: SettingMenuViewCell.identifier)

        let selectedItem = appInfoItems[indexPath.row] // 선택된 항목의 이름
        self.view.showBlockingView()

        // 액션 전용 항목
        if selectedItem.isActionOnly {
            self.view.hideBlockingView()
            requestReviewInAppstore()
            return
        }

        // content가 있는 경우에만 화면 전환
        guard let content = selectedItem.content else {
            self.view.hideBlockingView()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.view.hideBlockingView()
            let detailVC = DetailInfoVC(title: selectedItem.title, content: content)
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
