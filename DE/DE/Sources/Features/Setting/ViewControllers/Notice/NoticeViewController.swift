// Copyright © 2024 DRINKIG. All rights reserved
// 공지사항 목록 페이지
import UIKit

import SnapKit
import Then

import CoreModule
import Network

class NoticeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let navigationBarManager = NavigationBarManager()
    let noticeListView = UITableView()
    var noticeData : [NoticeResponse] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppColor.bgGray
        setupNavigationBar()
        setupUI()
    }
    
    private func setupNavigationBar() {
        navigationBarManager.setTitle(to: navigationItem, title: "공지사항", textColor: AppColor.black!)
    }
    
    private func setupUI(){
        [noticeListView].forEach {
            view.addSubview($0)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(35)
            make.leading.trailing.equalToSuperview()
            maek.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    // 테이블뷰 세팅하기
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeTableViewCell", for: indexPath)
        let data = self.noticeData[indexPath.row]
        
        // cell configure 함수로 세팅

        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // url로 웹뷰? 아니면 사파리서비스
    }
}
