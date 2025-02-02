// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import CoreModule
import Network

public class WishListViewController: UIViewController {
    
    private let navigationBarManager = NavigationBarManager()
    var wineResults: [WishResultModel] = []
    private let networkService = WishlistService()
    
    // 상태 변수 추가
    var shouldSkipWishlistUpdate = false
    
    private lazy var searchResultTableView = UITableView().then {
        $0.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "SearchResultTableViewCell")
        $0.separatorInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        $0.backgroundColor = Constants.AppColor.grayBG
        $0.dataSource = self
        $0.delegate = self
    }
    
    private lazy var noWineLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "위시리스트에 담긴 와인이 없어요.\n관심 있는 와인을 담아 보세요!"
        $0.setLineSpacingPercentage(0.3)
        $0.font = UIFont.ptdRegularFont(ofSize: 14)
        $0.textColor = AppColor.gray70
        $0.textAlignment = .center
        $0.isHidden = true
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        self.view.addSubview(indicator)
        setupNavigationBar()
        addComponents()
        setConstraints()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !shouldSkipWishlistUpdate {
            callFetchWishlistAPI()
        }
        shouldSkipWishlistUpdate = false
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
            action: #selector(backButtonTapped)
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
        [searchResultTableView, noWineLabel].forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        searchResultTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(11)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(18)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(651)
        }
        
        noWineLabel.snp.makeConstraints {
            $0.centerX.centerY.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func callFetchWishlistAPI() {
        Task {
            do {
                guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
                    print("❌ 유저 ID를 찾을 수 없습니다.")
                    return
                }
                 
                let isZero = try await APICallCounterManager.shared.isCallCountZero(for: userId, controllerName: .wishlist)
                
                if isZero {
                    // 호출 카운트가 0이면 캐시 사용
                    print("✅ 호출 카운트 0: 캐시 사용")
                    if let cachedWishlist = try? await WishlistDataManager.shared.fetchWishlist(for: userId) {
                        self.wineResults = cachedWishlist.map { data in
                            WishResultModel(wineId: data.wineId, imageUrl: data.imageUrl, wineName: data.wineName, sort: data.sort, price: data.price, vivinoRating: data.vivinoRating)
                        }
                        DispatchQueue.main.async {
                            self.searchResultTableView.reloadData()
                            self.noWineLabel.isHidden = !self.wineResults.isEmpty
                        }
                    }
                } else {
                    // 호출 카운트가 1 이상이면 API 호출
                    print("✅ 호출 카운트 1 이상: API 호출")
                    indicator.startAnimating()
                    networkService.fetchWishlist { [weak self] result in
                        guard let self = self else { return }
                        
                        switch result {
                        case .success(let responseData):
                            if let responseData = responseData {
                                self.wineResults = responseData.map { data in
                                    WishResultModel(wineId: data.wineId, imageUrl: data.imageUrl, wineName: data.name, sort: data.sort, price: data.price, vivinoRating: data.vivinoRating)
                                }
                                
                                // API 데이터로 캐시 덮어쓰기
                                Task {
                                    do {
                                        try await WishlistDataManager.shared.createWishlistIfNeeded(for: userId, with: self.wineResults.map { wine in
                                            WineData(wineId: wine.wineId,
                                                     imageUrl: wine.imageUrl,
                                                     wineName: wine.wineName,
                                                     sort: wine.sort,
                                                     price: wine.price,
                                                     vivinoRating: wine.vivinoRating
                                            )
                                        })
                                        try await WishlistDataManager.shared.updateWishlist(
                                            for: userId,
                                            with: self.wineResults.map { wine in
                                                WineData(wineId: wine.wineId,
                                                         imageUrl: wine.imageUrl,
                                                         wineName: wine.wineName,
                                                         sort: wine.sort,
                                                         price: wine.price,
                                                         vivinoRating: wine.vivinoRating
                                                )
                                            }
                                        )
                                        
                                        // 호출 카운트 초기화
                                        try await APICallCounterManager.shared.resetCallCount(for: userId, controllerName: .wishlist)
                                        indicator.stopAnimating()
                                    } catch {
                                        print("❌ 캐시 업데이트 또는 호출 카운트 초기화 실패: \(error.localizedDescription)")
                                        indicator.stopAnimating()
                                    }
                                }
                                
                                DispatchQueue.main.async {
                                    self.searchResultTableView.reloadData()
                                    self.noWineLabel.isHidden = !self.wineResults.isEmpty
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
        cell.configureWish(model: wine)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WineDetailViewController()
        vc.wineId = wineResults[indexPath.row].wineId
        navigationController?.pushViewController(vc, animated: true)
    }
}
