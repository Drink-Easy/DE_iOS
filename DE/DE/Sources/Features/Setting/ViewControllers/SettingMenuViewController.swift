// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network

public final class SettingMenuViewController : UIViewController {
    private var tableView = UITableView()
    
    private let settingMenuItems: [SettingMenuModel] = [
        SettingMenuItems.accountInfo,
        SettingMenuItems.wishList,
        SettingMenuItems.ownedWine,
        SettingMenuItems.schedule,
        SettingMenuItems.notice,
        SettingMenuItems.appInfo,
        SettingMenuItems.inquiry
    ]

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        tableView.frame = view.bounds
    }

}

extension SettingMenuViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingMenuItems.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = settingMenuItems[indexPath.row].name
        return cell
    }
}

extension SettingMenuViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = settingMenuItems[indexPath.row]
        let vc = selectedItem.viewControllerType.init() // 해당 뷰컨트롤러 생성
        navigationController?.pushViewController(vc, animated: true)
    }
}
