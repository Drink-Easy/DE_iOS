// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network
import SnapKit
import Then

public class SearchWineViewController : UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    let navigationBarManager = NavigationBarManager()
    // TODO : 상단 네비게이션 바 추가하는거 하셈!!
    var wineResults: [SearchResultModel] = []
    let networkService = WineService()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        view.backgroundColor = Constants.AppColor.grayBG
        self.view = searchHomeView
        
        searchHomeView.searchResultTableView.dataSource = self
        searchHomeView.searchResultTableView.delegate = self
        searchHomeView.searchResultTableView.register(
            SearchResultTableViewCell.self,
            forCellReuseIdentifier: "SearchResultTableViewCell"
        )
        searchHomeView.searchBar.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        setupNavigationBar()
    }
    
    private lazy var searchHomeView = SearchHomeView(
        titleText: "검색하고 싶은\n와인을 입력해주세요",
        placeholder: "검색어 입력"
    )
    
    private func setupNavigationBar() {
        navigationBarManager.setTitle(to: navigationItem, title: "", textColor: AppColor.black!)
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: AppColor.gray80!
        )
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)  //firstresponder가 전부 사라짐
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        let query = textField.text ?? ""
        filterSuggestions(with: query)
    }
    
    func filterSuggestions(with query: String) {
        if query.isEmpty {
            wineResults = []
            self.searchHomeView.searchResultTableView.reloadData()
        } else {
            callSearchAPI(query: query)
        }
    }
    
    func callSearchAPI(query: String) {
        networkService.fetchWines(searchName: query) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let responseData) :
                DispatchQueue.main.async {
                    self.wineResults = responseData.map { data in
                        SearchResultModel.init(wineId: data.wineId, name: data.name, nameEng: data.nameEng, imageUrl: data.imageUrl, sort: data.sort, country: data.country, region: data.region, variety: data.variety, vivinoRating: data.vivinoRating, price: data.price)
                    }
                    self.searchHomeView.searchResultTableView.reloadData()
                }
            case .failure(let error) :
                print("\(error)")
            }
        }
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
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
        let vc = TastedDateViewController()
        TNWineDataManager.shared.updateWineData(wineId: wineResults[indexPath.row].wineId, wineName: wineResults[indexPath.row].name, sort: wineResults[indexPath.row].sort, country: wineResults[indexPath.row].country, region: wineResults[indexPath.row].region, imageUrl: wineResults[indexPath.row].imageUrl, variety: wineResults[indexPath.row].variety)
        navigationController?.pushViewController(vc, animated: true)
    }
}

