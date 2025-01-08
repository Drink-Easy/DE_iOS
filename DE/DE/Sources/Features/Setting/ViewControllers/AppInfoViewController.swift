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
    
    private var tableView = UITableView()
    
    private let appInfoItems: [String] = [
        "서비스 이용약관", "개인정보 처리방침", "위치정보 이용약관", "오픈소스 라이브러리"
    ]
    
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
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - UI Setup
    private func setupNavigationBar() {
        navigationBarManager.setTitle(to: navigationItem, title: "앱 정보", textColor: AppColor.black!)
        navigationBarManager.addBackButton(to: navigationItem, target: self, action: #selector(backButtonTapped))
    }
    
    private func setupUI(){
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

//TODO: 뷰컨 or pdf?
extension AppInfoViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(appInfoItems[indexPath.row]) Tapped")
//        let selectedItem = settingMenuItems[indexPath.row]
//        let vc = selectedItem.viewControllerType.init() // 해당 뷰컨트롤러 생성
//        navigationController?.pushViewController(vc, animated: true)
    }
}
