// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then

import CoreModule
import DesignSystem
import Network

public class SearchHomeViewController : UIViewController, UITextFieldDelegate, FirebaseTrackable {
    public var screenName: String = Tracking.VC.searchHomeVC
    
    let navigationBarManager = NavigationBarManager()
    var wineResults: [SearchResultModel] = []
    let networkService = WineService()
    let errorHandler = NetworkErrorHandler()
    var isLoading = false
    var currentPage = 0
    var totalPage = 0
    
    private lazy var searchHomeView = SearchHomeView(
        titleText: "검색하고 싶은\n와인을 입력해주세요",
        placeholder: "와인 이름을 검색하세요 (한글/영문)"
    ).then {
        $0.searchResultTableView.dataSource = self
        $0.searchResultTableView.delegate = self
        $0.searchBar.delegate = self
        //$0.searchBar.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background
        self.view = searchHomeView
        searchHomeView.noSearchResultLabel.isHidden = true
        setupNavigationBar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(indicator)
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
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)  //firstresponder가 전부 사라짐
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let query = searchHomeView.searchBar.text, query.count >= 2 {
            DispatchQueue.main.async {
                // 강제로 맨위로 올리기
                self.searchHomeView.searchResultTableView.setContentOffset(.zero, animated: true)
            }
            Task {
                do {
                    self.view.showBlockingView()
                    try await callSearchAPI(query: query, startPage: 0)
                    searchHomeView.noSearchResultLabel.isHidden = !wineResults.isEmpty
                    self.view.hideBlockingView()
                } catch {
                    self.view.hideBlockingView()
                    errorHandler.handleNetworkError(error, in: self)
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
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            let placeholderText = "와인 이름을 검색하세요 (한글/영문)"
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholderText,
                attributes: [
                    .foregroundColor: AppColor.gray70,
                    .font: UIFont.pretendard(.regular, size: 14)
                ]
            )
        }
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
    
    func callSearchAPI(query: String, startPage: Int) async throws {
        guard let response = try await networkService.fetchWines(searchName: query, page: startPage) else { return }
        
        guard let content = response.content else { return }
        // reponse 와인 10개 매핑해주고
        let nextWineDatas = content.map { data in
            SearchResultModel(wineId: data.wineId, name: data.name, nameEng: data.nameEng, imageUrl: data.imageUrl, sort: data.sort, country: data.country, region: data.region, variety: data.variety, vivinoRating: data.vivinoRating, price: data.price)
        }
        
        // TODO : 와인 검색결과 표시 임시 처리
        let correctDatas = nextWineDatas.filter { $0.name.contains(query) || $0.nameEng.lowercased().contains(query.lowercased()) }
        
        let restDatas = nextWineDatas.filter { !correctDatas.contains($0) }
    
        if response.pageNumber != 0 { // 맨 처음 요청한게 아니면, 이전 데이터가 이미 저장이 되어있는 상황이면
            // 리스트 뒤에다가 넣어준다!
            self.currentPage = response.pageNumber
            self.wineResults.append(contentsOf: correctDatas)
            self.wineResults.append(contentsOf: restDatas)
        } else {
            // 토탈 페이지 수 갱신, 현재 페이지 수 설정
            self.totalPage = response.totalPages
            self.currentPage = response.pageNumber
            self.wineResults = correctDatas + restDatas
        }
        
        DispatchQueue.main.async {
            self.searchHomeView.searchResultTableView.reloadData()
        }
    }
}

extension SearchHomeViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
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
        let vc = WineDetailViewController()
        vc.wineId = wineResults[indexPath.row].wineId
        vc.wineName = wineResults[indexPath.row].name
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0 // 위쪽 바운스 막기
        }
        
        guard scrollView is UITableView else { return }
        
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
                    self.view.hideBlockingView()
                    errorHandler.handleNetworkError(error, in: self)
                }
                DispatchQueue.main.async {
                    self.searchHomeView.searchResultTableView.reloadData()
                }
                isLoading = false
            }
        }
    }
}
