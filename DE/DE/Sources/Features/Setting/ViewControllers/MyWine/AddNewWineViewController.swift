// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network
import SnapKit
import Then

public class AddNewWineViewController : UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, FirebaseTrackable {
    public var screenName: String = Tracking.VC.createMyWineVC
    
    let navigationBarManager = NavigationBarManager()
    var wineResults: [SearchResultModel] = []
    var registerWine: MyOwnedWine = MyOwnedWine()
    let networkService = WineService()
    var isLoading = false
    var currentPage = 0
    var totalPage = 0
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        view.backgroundColor = AppColor.grayBG
        self.view = searchHomeView
        searchHomeView.noSearchResultLabel.isHidden = true
        self.view.addSubview(indicator)
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
    
    private lazy var searchHomeView = SearchHomeView(
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
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
    }
    
    func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(backButtonTapped)
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
            self.view.showBlockingView()
            DispatchQueue.main.async {
                // 강제로 맨위로 올리기
                self.searchHomeView.searchResultTableView.setContentOffset(.zero, animated: true)
            }
            Task {
                do {
                    try await callSearchAPI(query: query, startPage: 0)
                    searchHomeView.noSearchResultLabel.isHidden = !wineResults.isEmpty
                    self.view.hideBlockingView()
                } catch {
                    print(error)
                    self.view.hideBlockingView()
                }
            }
            textField.resignFirstResponder()
            return true
        } else {
            showCharacterLimitAlert()
            textField.resignFirstResponder()
        }
        return true
    }

    private func showCharacterLimitAlert() {
        let alert = UIAlertController(title: "", message: "검색어를 2자 이상 입력해 주세요.", preferredStyle: .alert)
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
    
    func callSearchAPI(query: String, startPage: Int) async throws {
        
        guard let response = try await networkService.fetchWines(searchName: query, page: startPage) else { return }
        
        guard let content = response.content else { return }
        // reponse 와인 10개 매핑해주고
        let nextWineDatas = content.map { data in
            SearchResultModel(wineId: data.wineId, name: data.name, nameEng: data.nameEng, imageUrl: data.imageUrl, sort: data.sort, country: data.country, region: data.region, variety: data.variety, vivinoRating: data.vivinoRating, price: data.price)
        }
        
        if response.pageNumber != 0 { // 맨 처음 요청한게 아니면, 이전 데이터가 이미 저장이 되어있는 상황이면
            // 리스트 뒤에다가 넣어준다!
            self.currentPage = response.pageNumber
            self.wineResults.append(contentsOf: nextWineDatas)
        } else {
            // 토탈 페이지 수 갱신, 현재 페이지 수 설정
            self.totalPage = response.totalPages
            self.currentPage = response.pageNumber
            self.wineResults = nextWineDatas
        }
        DispatchQueue.main.async {
            self.searchHomeView.searchResultTableView.reloadData()
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
        let searchText = searchHomeView.searchBar.text ?? ""
        cell.configureSearch(model: wine, highlightText: searchText.isEmpty ? nil : searchText)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        logCellClick(screenName: screenName, indexPath: indexPath, cellName: Tracking.CellEvent.searchWineCellTapped, fileName: #file, cellID: "SearchResultTableViewCell")
        let vc = BuyNewWineDateViewController()
        let selectedWine = wineResults[indexPath.row]
        MyOwnedWineManager.shared.setWineId(selectedWine.wineId)
        MyOwnedWineManager.shared.setWineName(selectedWine.name)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0 // 위쪽 바운스 막기
        }
        
        guard let tableView = scrollView as? UITableView else { return }
        
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let scrollViewHeight = scrollView.frame.size.height
        
        // Check if user has scrolled to the bottom
        if contentOffsetY > contentHeight - scrollViewHeight { // Trigger when arrive the bottom
            guard !isLoading, currentPage + 1 < totalPage else { return }
            isLoading = true
            self.view.showBlockingView()
            Task {
                do {
                    try await callSearchAPI(query: searchHomeView.searchBar.text ?? "", startPage: currentPage + 1)
                    self.view.hideBlockingView()
                } catch {
                    print("Failed to fetch next page: \(error)")
                    self.view.hideBlockingView()
                }
                DispatchQueue.main.async {
                    self.searchHomeView.searchResultTableView.reloadData()
                }
                isLoading = false
            }
        }
    }
}

