// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import CoreModule
import Then

class MoreLikelyWineViewController: UIViewController {

    let navigationBarManager = NavigationBarManager()
    let userDataManager = UserDataManager.shared
    let wineDataManger = WineDataManager.shared
    
    var userName = ""
    private var wineList: [WineData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        self.view = moreLikelyWineView
        setupNavigationBar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        Task {
            wineList = await wineDataManger.fetchWines(type: .recommended)
            print("✅ 불러온 와인 데이터: \(wineList.count)개")
        }
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @MainActor
    private func fetchWineData() async {
        wineList = wineDataManger.fetchWines(type: .recommended)
        moreLikelyWineView.moreWineTableView.reloadData()
    }
    
    private lazy var moreLikelyWineView = MoreRecomWineView().then {
        $0.title.text = "\(userName) 님이 좋아할 만한 와인"
        $0.title.setPartialTextStyle(text: $0.title.text ?? "", targetText: "\(userName)", color: AppColor.purple100 ?? .purple, font: UIFont.ptdSemiBoldFont(ofSize: 30))
        
        $0.moreWineTableView.dataSource = self
        $0.moreWineTableView.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: AppColor.gray70!
        )
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }

}

extension MoreLikelyWineViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wineList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MoreWineTableViewCell", for: indexPath) as? MoreWineTableViewCell else {
            return UITableViewCell()
        }
        
        let wine = wineList[indexPath.row]
        cell.configure(model: wine)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = WineDetailViewController()
//        vc.wineId = wineResults[indexPath.row].wineId
//        navigationController?.pushViewController(vc, animated: true)
    }
}
