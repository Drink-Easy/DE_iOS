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
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 현재 텍스트
        let currentText = searchHomeView.searchBar.text ?? ""
        
        // 한글 조합 중인 텍스트 (markedTextRange가 nil이 아니면 조합 중)
        if let markedTextRange = searchHomeView.searchBar.markedTextRange,
           let _ = searchHomeView.searchBar.position(from: markedTextRange.start, offset: 0) {
            return true // 조합 중인 텍스트는 제한하지 않음
        }
        
        // 입력 후 텍스트
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if updatedText.count >= 2 {
            // 경고 표시
            showCharacterLimitAlert()
            return false
        }
        
        callSearchAPI(query: updatedText)
        
        // 글자 수 제한
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
    
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: AppColor.gray70!
        )
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
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
                            satisfaction: data.vivinoRating,
                            area: data.area
                        )
                    }
                    self.searchHomeView.searchResultTableView.reloadData()
                }
            case .failure(let error) :
                print("\(error)")
            }
        }
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
        cell.configure(model: wine, highlightText: searchText.isEmpty ? nil : searchText)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WineDetailViewController()
        vc.wineId = wineResults[indexPath.row].wineId
        navigationController?.pushViewController(vc, animated: true)
    }
}
