// Copyright © 2024 DRINKIG. All rights reserved
// 공지사항 목록 페이지

import UIKit

import SnapKit
import Then

import CoreModule
import DesignSystem
import Network

import SafariServices

class NoticeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FirebaseTrackable {
    var screenName: String = Tracking.VC.noticeVC
    
    private let navigationBarManager = NavigationBarManager()
    private let networkService = NoticeService()
    var noticeData : [NoticeResponse] = []
    private let errorHandler = NetworkErrorHandler()
    
    private lazy var noticeListView = UITableView().then {
        $0.register(NoticeTableViewCell.self, forCellReuseIdentifier: NoticeTableViewCell.identifier)
        $0.separatorInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        $0.backgroundColor = AppColor.background
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .singleLine
        $0.rowHeight = 50
        $0.estimatedRowHeight = 50
        $0.dataSource = self
        $0.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = AppColor.background
        setupNavigationBar()
        setupUI()
        callNoticeAPI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(indicator)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        setNavBarAppearance(navigationController: self.navigationController)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
    }
    
    private func setupNavigationBar() {
        navigationBarManager.setTitle(to: navigationItem, title: "공지사항", textColor: AppColor.black)
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
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(8))
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func callNoticeAPI() {
        view.showBlockingView()
        Task {
            do {
                let data = try await networkService.fetchAllNotices()
                DispatchQueue.main.async {
                    self.noticeData = data
                    self.view.hideBlockingView()
                    self.noticeListView.reloadData()
                }
            } catch {
                self.view.hideBlockingView()
                errorHandler.handleNetworkError(error, in: self)
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
        logCellClick(screenName: screenName, indexPath: indexPath, cellName: Tracking.CellEvent.noticeCellTapped, fileName: #file, cellID: NoticeTableViewCell.identifier)
        let data = self.noticeData[indexPath.row]
        
        if let url = URL(string: data.contentUrl) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
}
