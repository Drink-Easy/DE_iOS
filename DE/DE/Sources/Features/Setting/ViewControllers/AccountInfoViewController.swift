// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule
import Network

class AccountInfoViewController: UIViewController {

    private let navigationBarManager = NavigationBarManager()
    private var userProfile: MemberInfoResponse?
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 60
    }
    
    private let tableView = UITableView().then {
        $0.backgroundColor = .white // 테이블 뷰 배경색
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.rowHeight = 40
        $0.layer.cornerRadius = 12 // 코너 반경 설정
        $0.layer.masksToBounds = true // 코너 반경 적용
    }
    
    private let logoutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(AppColor.gray50, for: .normal)
        $0.titleLabel?.font = UIFont.ptdMediumFont(ofSize: 11)
    }
    
    private let deleteButton = UIButton().then {
        $0.setTitle("탈퇴하기", for: .normal)
        $0.setTitleColor(AppColor.gray50, for: .normal)
        $0.titleLabel?.font = UIFont.ptdMediumFont(ofSize: 11)
    }
    
    private var infoItems: [(String, String)] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
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
        tableView.dataSource = self
        tableView.delegate = self
        fetchUserProfile()
    }
    
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
    
    private func setupUI() {
        [profileImageView, tableView, logoutButton, deleteButton].forEach {
            view.addSubview($0)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(200) // 적절히 설정 가능
        }
        
        logoutButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.trailing.equalTo(view.snp.centerX).offset(-16)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.centerY.equalTo(logoutButton)
            make.leading.equalTo(view.snp.centerX).inset(16)
        }
    }
    
    private func fetchUserProfile() {
        // Mock network request
        let jsonData = """
        {
            "imageUrl": "null",
            "username": "null",
            "email": "Newnew1@g.com",
            "city": "null",
            "authType": "Drinkeg",
            "adult": false
        }
        """.data(using: .utf8)!
        
        do {
            let profile = try JSONDecoder().decode(MemberInfoResponse.self, from: jsonData)
            self.userProfile = profile
            updateUI(with: profile)
        } catch {
            print("Failed to decode user profile: \(error)")
        }
    }
    
    private func updateUI(with profile: MemberInfoResponse) {
        if let url = URL(string: profile.imageUrl) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profileImageView.image = image
                    }
                }
            }
        } else {
            profileImageView.image = UIImage(named: "profilePlaceholder")
        }
        
        infoItems = [
            ("닉네임", profile.username ?? "설정되지 않음"),
            ("내 동네", profile.city ?? "설정되지 않음"),
            ("이메일", profile.email ?? "이메일 없음"),
            ("연동 상태", profile.authType ?? "알 수 없음"),
            ("성인 인증", profile.adult ? "인증 완료" : "미인증")
        ]
        
        tableView.reloadData()
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func goToProfileEditView() {
        let vc = ProfileEditVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension AccountInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return infoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "InfoCell")
        cell.selectionStyle = .none
        cell.textLabel?.text = infoItems[indexPath.row].0
        cell.textLabel?.font = UIFont.ptdRegularFont(ofSize: 14)
        cell.textLabel?.textColor = AppColor.black ?? .black
        
        cell.detailTextLabel?.text = infoItems[indexPath.row].1
        cell.detailTextLabel?.font = UIFont.ptdRegularFont(ofSize: 14)
        cell.detailTextLabel?.textColor = AppColor.gray50 ?? .gray
        
        return cell
    }
}
