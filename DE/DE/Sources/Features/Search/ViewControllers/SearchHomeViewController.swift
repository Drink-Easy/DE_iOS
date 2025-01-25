// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import SnapKit
import Then
import Network

public class SearchHomeViewController : UIViewController, UITextFieldDelegate {
    
    let navigationBarManager = NavigationBarManager()
    var wineResults: [SearchResultModel] = []
    let networkService = WineService()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.AppColor.grayBG
        self.view = searchHomeView
        setupNavigationBar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private lazy var searchHomeView = SearchHomeView(
        titleText: "검색하고 싶은\n와인을 입력해주세요",
        placeholder: "검색어 입력"
    ).then {
        $0.searchResultTableView.dataSource = self
        $0.searchResultTableView.delegate = self
        $0.searchBar.delegate = self
        //$0.searchBar.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)  //firstresponder가 전부 사라짐
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let query = searchHomeView.searchBar.text, query.count >= 2 {
            Task {
                do {
                    try await callSearchAPI(query: query)
                } catch {
                    print(error)
                }
            }
            return true
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
//    self.searchHomeView.searchResultTableView.reloadData()
//        }
//    }
    
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
    
    func callSearchAPI(query: String) async throws {
        let startPage = 0
        
        guard let response = try await networkService.fetchWines(searchName: query, page: startPage) else { return }
        
        guard let content = response.content else { return }
        // reponse 와인 10개 매핑해주고
        let nextWineDatas = content.map { data in
            SearchResultModel(wineId: data.wineId, name: data.name, nameEng: data.nameEng, imageUrl: data.imageUrl, sort: data.sort, country: data.country, region: data.region, variety: data.variety, vivinoRating: data.vivinoRating, price: data.price)
        }
        
        if response.pageNumber != 0 { // 맨 처음 요청한게 아니면, 이전 데이터가 이미 저장이 되어있는 상황이면
            // 리스트 뒤에다가 넣어준다!
            // 이 페이지에 잇는 self.currentPage = response.pageNumber
            // totalpage도 저장 -> 안해줘도되긴함(이미 이전에 0번 페이지 요청때 이미 갱신했으니까)
            self.wineResults.append(contentsOf: nextWineDatas)
        } else {
            // 토탈 페이지 수 갱신
            // 현재 페이지 수도 갱신 self.currentPage = response.pageNumber
            self.wineResults = nextWineDatas
        }
//      self.searchHomeView.searchResultTableView.reloadData()
    }
}

extension SearchHomeViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wineResults.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultTableViewCell", for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        
        let wine = wineResults[indexPath.row]
        let searchText = searchHomeView.searchBar.text ?? ""
        cell.configureSearch(model: wine, highlightText: searchText.isEmpty ? nil : searchText)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WineDetailViewController()
        vc.wineId = wineResults[indexPath.row].wineId
        navigationController?.pushViewController(vc, animated: true)
    }
}
