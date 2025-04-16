// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import DesignSystem
import Network
import SnapKit
import Then

public class SearchWineViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, FirebaseTrackable {
    public var screenName: String = Tracking.VC.tnSearchWineVC
    
    let navigationBarManager = NavigationBarManager()
    var wineResults: [SearchResultModel] = []
    let networkService = WineService()
    let errorHandler = NetworkErrorHandler()
    var isLoading = false
    var currentPage = 0
    var totalPage = 0
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(indicator)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        view.backgroundColor = AppColor.background
        self.view = searchHomeView
        searchHomeView.noSearchResultLabel.isHidden = true
        searchHomeView.searchResultTableView.dataSource = self
        searchHomeView.searchResultTableView.delegate = self
        searchHomeView.searchResultTableView.register(
            SearchResultTableViewCell.self,
            forCellReuseIdentifier: "SearchResultTableViewCell"
        )
        //searchHomeView.searchBar.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        setupNavigationBar()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
    }
    
    private lazy var searchHomeView = SearchHomeView(
        titleText: SearchConstants.titleText,
        placeholder: SearchConstants.textFieldPlaceholder
    ).then {
        $0.searchBar.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationBarManager.setTitle(to: navigationItem, title: "", textColor: AppColor.black)
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC)
        )
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)  //firstresponder가 전부 사라짐
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        defer { textField.resignFirstResponder() }
        
        guard let query = searchHomeView.searchBar.text, query.count >= 2 else {
            showCharacterLimitAlert()
            return true
        }
        
        Task {
            await MainActor.run {
                self.searchHomeView.searchResultTableView.setContentOffset(.zero, animated: true)
                self.view.showBlockingView()
            }

            do {
                try await callSearchAPI(query: query, startPage: 0)

                await MainActor.run {
                    searchHomeView.noSearchResultLabel.isHidden = !wineResults.isEmpty
                    self.view.hideBlockingView()
                }
            } catch {
                await MainActor.run {
                    self.view.hideBlockingView()
                    self.errorHandler.handleNetworkError(error, in: self)
                }
            }
        }
        
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            let placeholderText = SearchConstants.textFieldPlaceholder
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
        
        let vc = TastedDateViewController()
        TNWineDataManager.shared.updateWineData(wineId: wineResults[indexPath.row].wineId, wineName: wineResults[indexPath.row].name, sort: wineResults[indexPath.row].sort, country: wineResults[indexPath.row].country, region: wineResults[indexPath.row].region, imageUrl: wineResults[indexPath.row].imageUrl, variety: wineResults[indexPath.row].variety)
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

