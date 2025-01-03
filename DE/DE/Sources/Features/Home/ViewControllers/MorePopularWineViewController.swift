// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import CoreModule
import Then

class MorePopularWineViewController: UIViewController {

    let navigationBarManager = NavigationBarManager()
    let dataManger = WineDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        self.view = morePopularWineView
        
        setupNavigationBar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private lazy var morePopularWineView = MoreRecomWineView().then {
        $0.title.text = "지금 가장 인기있는 와인 🔥"
        
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

extension MorePopularWineViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dataManger.fetchWines(type: .popular).count
        return 10
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MoreWineTableViewCell", for: indexPath) as? MoreWineTableViewCell else {
            return UITableViewCell()
        }
        
//        let wineList = dataManger.fetchWines(type: .popular)
//        let wine = wineList[indexPath.row]
//        cell.configure(model: wine)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = WineDetailViewController()
//        vc.wineId = wineResults[indexPath.row].wineId
//        navigationController?.pushViewController(vc, animated: true)
    }
}
