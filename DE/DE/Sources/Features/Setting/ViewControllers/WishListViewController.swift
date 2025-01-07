// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import CoreModule

class WishListViewController: UIViewController {
    
    private let navigationBarManager = NavigationBarManager()
    var wineResults: [SearchResultModel] = []
    private let networkService = WishlistService()
    
    private lazy var searchResultTableView = UITableView().then {
        $0.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "SearchResultTableViewCell")
        $0.separatorInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        $0.backgroundColor = Constants.AppColor.grayBG
        $0.dataSource = self
        $0.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        setupNavigationBar()
        addComponents()
        setConstraints()
        callFetchWishlistAPI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(backButtonTapped),
            tintColor: AppColor.gray70!
        )
        
        navigationBarManager.setTitle(
            to: navigationItem,
            title: "위시리스트",
            textColor: AppColor.black ?? .black
        )
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func addComponents() {
        [searchResultTableView].forEach { view.addSubview($0) }
    }

    private func setConstraints() {
        searchResultTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(11)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(18)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func callFetchWishlistAPI() {
        networkService.fetchWishlist() { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let responseData) :
                DispatchQueue.main.async {
                    self.wineResults = responseData.map { data in
                        SearchResultModel(
                            wineId: data.wineId,
                            wineName: data.name,
                            imageURL: data.imageUrl,
                            sort: data.sort,
                            satisfaction: data.vivinoRating,
                            area: data.area
                        )
                    }
                    self.searchResultTableView.reloadData()
                }
            case .failure(let error) :
                print("\(error)")
            }
        }
    }

}

extension WishListViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wineResults.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        
        let wine = wineResults[indexPath.row]
        cell.configure(model: wine)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WineDetailViewController()
        vc.wineId = wineResults[indexPath.row].wineId
        navigationController?.pushViewController(vc, animated: true)
    }
}
