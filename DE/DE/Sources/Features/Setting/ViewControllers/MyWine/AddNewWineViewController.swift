// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network
import SnapKit
import Then

public class AddNewWineViewController : UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let navigationBarManager = NavigationBarManager()
    var wineResults: [SearchResultModel] = []
    var registerWine: MyOwnedWine = MyOwnedWine()
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
        searchHomeView.searchBar.delegate = self
//        searchHomeView.searchBar.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        setupNavigationBar()
    }
    
    private lazy var searchHomeView = AddNewWineView(
        titleText: "추가할 와인을 선택해주세요",
        placeholder: "와인 이름을 적어 검색"
    )
    
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
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)  //firstresponder가 전부 사라짐
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let query = searchHomeView.searchBar.text, query.count >= 2 {
            callSearchAPI(query: query)
        } else {
            showCharacterLimitAlert()
        }
        return true
    }

    private func showCharacterLimitAlert() {
        let alert = UIAlertController(title: "경고", message: "최소 2자 이상 입력해 주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
//    @objc
//    private func textFieldDidChange(_ textField: UITextField) {
//        let query = textField.text ?? ""
//        filterSuggestions(with: query)
//    }
//    
//    func filterSuggestions(with query: String) {
//        if query.isEmpty {
//            wineResults = []
//            self.searchHomeView.searchResultTableView.reloadData()
//        } else {
//            callSearchAPI(query: query)
//        }
//    }
    
    func callSearchAPI(query: String) {
        networkService.fetchWines(searchName: query) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let responseData) :
                DispatchQueue.main.async {
                    self.wineResults = responseData.map { data in
                        SearchResultModel(wineId: data.wineId, name: data.name, nameEng: data.nameEng, imageUrl: data.imageUrl, sort: data.sort, country: data.country, region: data.region, variety: data.variety, vivinoRating: data.vivinoRating, price: data.price)
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
        cell.configureSearch(model: wine)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TastedDateViewController()
        let selectedWine = wineResults[indexPath.row]
        registerWine.updateWine(wineId: selectedWine.wineId, wineName: selectedWine.name)
        vc.registerWine = self.registerWine
        navigationController?.pushViewController(vc, animated: true)
    }
}

