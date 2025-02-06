// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import CoreModule
import Network
import Then

class MoreLikelyWineViewController: UIViewController {

    let navigationBarManager = NavigationBarManager()
    let networkService = WineService()
    
    public var userName: String = "" {
        didSet {
            updateLikeWineListView()
        }
    }
    
    public var recommendWineDataList: [HomeWineModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        self.view = moreLikelyWineView
        self.moreLikelyWineView.title.setPartialTextStyle(text: moreLikelyWineView.title.text ?? "", targetText: "\(userName)", color: AppColor.purple100 ?? .purple, font: UIFont.ptdSemiBoldFont(ofSize: 30))
        setupNavigationBar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.view.addSubview(indicator)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    // MARK: - 네트워크 요청 처리
    private lazy var moreLikelyWineView = MoreRecomWineView().then {
        $0.title.text = "\(userName)님을 위한 추천 와인"
        $0.moreWineTableView.dataSource = self
        $0.moreWineTableView.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC)
        )
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    private func updateLikeWineListView() {
        moreLikelyWineView.title.text = "\(userName)님을 위한 추천 와인"
        moreLikelyWineView.title.setPartialTextStyle(
            text: moreLikelyWineView.title.text ?? "",
            targetText: "\(userName)",
            color: AppColor.purple100 ?? .purple,
            font: UIFont.ptdSemiBoldFont(ofSize: 30)
        )
    }
}

extension MoreLikelyWineViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recommendWineDataList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MoreWineTableViewCell", for: indexPath) as? MoreWineTableViewCell else {
            return UITableViewCell()
        }
        
        let wine = recommendWineDataList[indexPath.row]
        cell.configure(model: wine)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WineDetailViewController()
        vc.wineId = recommendWineDataList[indexPath.row].wineId
        vc.wineName = recommendWineDataList[indexPath.row].wineName
        navigationController?.pushViewController(vc, animated: true)
    }
}
