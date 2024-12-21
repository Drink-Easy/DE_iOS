//
//  SearchHomeViewController.swift
//  Drink-EG
//
//  Created by 김도연 on 7/20/24.
//

import UIKit
import SnapKit
import Then

class SearchHomeViewController : UIViewController, UISearchBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#F8F8FA")
        self.view = searchHomeView
    }
    
    private lazy var searchHomeView = SearchHomeView().then {
        $0.searchResultTableView.dataSource = self
        $0.searchResultTableView.delegate = self
    }
}

extension SearchHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        
//        cell.configure(model: data[indexPath.row])
        return cell
    }
}
