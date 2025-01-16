// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import CoreModule
import Network

public class WishListViewController: UIViewController {
    
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
    
    public override func viewDidLoad() {
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
            make.height.equalTo(651)
        }
    }
    
    func callFetchWishlistAPI() {
        Task {
            do {
                // UserDefaults에서 userId 가져오기
                guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
                    print("❌ 유저 ID를 찾을 수 없습니다.")
                    return
                }
                
                // 호출 카운트 확인
                let isZero = try await APICallCounterManager.shared.isCallCountZero(for: userId, controllerName: .wishlist)
                
                if isZero {
                    // 호출 카운트가 0이면 캐시 사용
                    print("✅ 호출 카운트 0: 캐시 사용")
                    if let cachedWishlist = try? await WishlistDataManager.shared.fetchWishlist(for: userId) {
                        self.wineResults = cachedWishlist.map { data in
                            SearchResultModel(
                                wineId: data.wineId,
                                wineName: data.wineName,
                                imageURL: data.imageURL,
                                sort: data.sort,
                                satisfaction: data.satisfaction,
                                country: data.country,
                                region: data.region
                            )
                        }
                        DispatchQueue.main.async {
                            self.searchResultTableView.reloadData()
                        }
                    }
                } else {
                    // 호출 카운트가 1 이상이면 API 호출
                    print("✅ 호출 카운트 1 이상: API 호출")
                    networkService.fetchWishlist { [weak self] result in
                        guard let self = self else { return }
                        
                        switch result {
                        case .success(let responseData):
                            if let responseData = responseData {
                                self.wineResults = responseData.map { data in
                                    SearchResultModel(
                                        wineId: data.wineId,
                                        wineName: data.name,
                                        imageURL: data.imageUrl,
                                        sort: data.sort,
                                        satisfaction: data.vivinoRating,
                                        country: data.country,
                                        region: data.region
                                    )
                                }
                                
                                // API 데이터로 캐시 덮어쓰기
                                Task {
                                    do {
                                        try await WishlistDataManager.shared.updateWishlist(
                                            for: userId,
                                            with: self.wineResults.map { wine in
                                                WineData(wineId: wine.wineId,
                                                         wineName: wine.wineName,
                                                         imageURL: wine.imageURL,
                                                         sort: wine.sort,
                                                         satisfaction: wine.satisfaction,
                                                         country: wine.country,
                                                         region: wine.region
                                                )
                                            }
                                        )
                                        
                                        // 호출 카운트 초기화
                                        try await APICallCounterManager.shared.resetCallCount(for: userId, controllerName: .wishlist)
                                    } catch {
                                        print("❌ 캐시 업데이트 또는 호출 카운트 초기화 실패: \(error.localizedDescription)")
                                    }
                                }
                                
                                DispatchQueue.main.async {
                                    self.searchResultTableView.reloadData()
                                }
                            }
                        case .failure(let error):
                            print("❌ 위시리스트 API 호출 실패: \(error.localizedDescription)")
                        }
                    }
                }
            } catch {
                print("❌ 호출 카운트 확인 실패: \(error.localizedDescription)")
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
