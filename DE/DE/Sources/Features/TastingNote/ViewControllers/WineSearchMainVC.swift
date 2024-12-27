// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import SnapKit
import Then

public class WineSearchMainVC : UIViewController, UISearchBarDelegate {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.AppColor.grayBG
        self.view = searchHomeView
    }
    
    private lazy var searchHomeView = SearchView().then {
        $0.searchResultTableView.dataSource = self
        $0.searchResultTableView.delegate = self
    }
}

extension WineSearchMainVC: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
//        cell.configure(model: data[indexPath.row])
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = WineDetailViewController()
//        navigationController?.pushViewController(vc, animated: true)
    }
}
