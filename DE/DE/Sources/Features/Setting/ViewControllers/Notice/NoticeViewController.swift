// Copyright © 2024 DRINKIG. All rights reserved
// 공지사항 목록 페이지

import UIKit

import SnapKit
import Then

import CoreModule
import Network

class NoticeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let navigationBarManager = NavigationBarManager()
    private let networkService = NoticeService()
    var noticeData : [NoticeResponse] = []
    
    private lazy var noticeListView = UITableView().then {
        $0.register(NoticeTableViewCell.self, forCellReuseIdentifier: NoticeTableViewCell.identifier)
        $0.separatorInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        $0.backgroundColor = Constants.AppColor.grayBG
        $0.rowHeight = 50
        $0.estimatedRowHeight = 50
        $0.dataSource = self
        $0.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppColor.bgGray
        setupNavigationBar()
        setupUI()
        callNoticeAPI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(indicator)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupNavigationBar() {
        navigationBarManager.setTitle(to: navigationItem, title: "공지사항", textColor: AppColor.black!)
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI(){
        [noticeListView].forEach {
            view.addSubview($0)
        }
        
        noticeListView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(35)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func callNoticeAPI() {
        self.view.showBlockingView()
        networkService.fetchAllNotices() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let responseData) :
                DispatchQueue.main.async {
                    self.noticeData = responseData!
                    self.noticeListView.reloadData()
                }
                self.view.hideBlockingView()
            case .failure(let error) :
                print("\(error)")
                self.view.hideBlockingView()
            }
        }
    }
    
    // 테이블뷰 세팅하기
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeData.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoticeTableViewCell.identifier, for: indexPath) as? NoticeTableViewCell else {
            return UITableViewCell()
        }
        let data = self.noticeData[indexPath.row]
        cell.configure(data: data)

        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.noticeData[indexPath.row]
        
        guard let url = URL(string: data.contentUrl) else {
            return
        }
        
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
