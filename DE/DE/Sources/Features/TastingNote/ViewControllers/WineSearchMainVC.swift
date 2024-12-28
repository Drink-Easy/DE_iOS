// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network
import SnapKit
import Then

public class WineSearchMainVC : UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    let navigationBarManager = NavigationBarManager()
    var wineResults: [SearchResultModel] = []
    let networkService = WineService()
    let noteService = TastingNoteService()
    
    /*
    func callPost() {
        let d = noteService.makePostNoteDTO(wineId: 584297, color: "#892222", tasteDate: "2024-12-18", sugarContent: 5, acidity: 5, tannin: 5, body: 5, alcohol: 5, nose: ["붓꽃", "장미", "금작화"], rating: 5.0, review: "첫번째 리뷰에용")
        
        noteService.postNote(data: d) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let str):
                print(str)
            case .failure(let error):
                print(error)
            }
        }
    }*/
    
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
//        callPost() 테스트용
    }
    
    private lazy var searchHomeView = SearchHomeView(
        titleText: "먼저,\n기록할 와인을 선택해주세요",
        placeholder: "와인 이름을 적어 검색"
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
                        SearchResultModel(
                            wineId: data.wineId,
                            wineName: data.name,
                            imageURL: data.imageUrl,
                            sort: data.sort,
                            satisfaction: data.vivinoRating
                        )
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
        UserDefaults.standard.set(wineResults[indexPath.row].wineId, forKey: "wineId")
        print("와인id 저장됨: \(wineResults[indexPath.row].wineId)")
        navigationController?.pushViewController(vc, animated: true)
    }
}

