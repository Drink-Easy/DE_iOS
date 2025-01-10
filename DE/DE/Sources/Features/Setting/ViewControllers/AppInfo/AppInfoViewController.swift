// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then
import SDWebImage

import CoreModule
import Network

class AppInfoViewController : UIViewController {
    
    let navigationBarManager = NavigationBarManager()
    
    private let networkService = MemberService()
    private var memberData: MemberInfoResponse?
    
    private lazy var appVersion: String = {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }()
    
    private var tableView = UITableView()
    
    private let appInfoItems: [String] = [
        "서비스 이용약관", "개인정보 처리방침", "위치정보 이용약관", "오픈소스 라이브러리"
    ]
    
    lazy var appVersionLabel = UILabel().then {
        $0.text = "버전 정보"
        $0.font = UIFont.ptdMediumFont(ofSize: 14)
        $0.textColor = AppColor.gray70
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        appVersionLabel.text = "버전 정보 \(appVersion)"
        setupTableView()
        setupUI()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.rowHeight = 50
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: - UI Setup
    private func setupNavigationBar() {
        navigationBarManager.setTitle(to: navigationItem, title: "앱 정보", textColor: AppColor.black!)
        navigationBarManager.addBackButton(to: navigationItem, target: self, action: #selector(backButtonTapped))
    }
    
    private func setupUI(){
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.leading.equalToSuperview()
            make.height.equalTo(200)
        }
        
        view.addSubview(appVersionLabel)
        appVersionLabel.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(20)
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}

extension AppInfoViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appInfoItems.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.text = appInfoItems[indexPath.row]
        cell.textLabel?.font = UIFont.ptdRegularFont(ofSize: 16)
        cell.textLabel?.textColor = AppColor.black
        cell.selectionStyle = .none

        // Chevron 추가
        let chevronImage = UIImageView(image: UIImage(systemName: "chevron.right"))
        chevronImage.tintColor = AppColor.gray70
        cell.accessoryView = chevronImage

        return cell
    }
}

extension AppInfoViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = appInfoItems[indexPath.row] // 선택된 항목의 이름
        var content: String
        
        // 선택된 항목에 따라 다른 내용 설정
        switch selectedItem {
        case "서비스 이용약관":
            content = "서비스 이용약관의 내용입니다.\n\n1. 약관 개요\n2. 이용 조건\n3. 제한 사항\n..."
        case "개인정보 처리방침":
            content = "개인정보 처리방침의 내용입니다.\n\n1. 개인정보 수집 목적\n2. 제공 및 보관 기간\n..."
        case "위치정보 이용약관":
            content = "위치정보 이용약관의 내용입니다.\n\n1. 위치 데이터 사용 정책\n2. 서비스 제한\n..."
        case "오픈소스 라이브러리":
            content = "오픈소스 라이브러리 목록입니다.\n\n- Alamofire\n- SDWebImage\n- SnapKit\n..."
        default:
            content = "정보를 찾을 수 없습니다."
        }
        
        let detailVC = DetailInfoVC(title: selectedItem, content: content)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
