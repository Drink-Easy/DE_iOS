// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import CoreModule
import Network

public class WishListViewController: UIViewController, FirebaseTrackable {
    public var screenName: String = Tracking.VC.wishlistVC
    
    private let navigationBarManager = NavigationBarManager()
    var wineResults: [WishResultModel] = []
    private let networkService = WishlistService()
    
    private let errorHandler = NetworkErrorHandler()
    
    private lazy var searchResultTableView = UITableView().then {
        $0.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "SearchResultTableViewCell")
        $0.separatorInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        $0.backgroundColor = AppColor.grayBG
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
    }
    
    private lazy var noWineLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "위시리스트에 담긴 와인이 없어요.\n관심 있는 와인을 담아 보세요!"
        $0.setLineSpacingPercentage(0.3)
        $0.font = UIFont.ptdRegularFont(ofSize: 14)
        $0.textColor = AppColor.gray70
        $0.textAlignment = .center
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        setupNavigationBar()
        addComponents()
        setConstraints()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.addSubview(indicator)
        logScreenView(fileName: #file)
        callFetchAPI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        setNavBarAppearance(navigationController: self.navigationController)
        self.view.showBlockingView()
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
    
    func callFetchAPI() {
        Task {
            do {
                let responseData = try await networkService.fetchWishlist()
                if let responseData = responseData {
                    self.updateUI(data: responseData)
                }
            } catch {
                view.hideBlockingView()
                errorHandler.handleNetworkError(error, in: self)
            }
        }
    }
    
    private func updateUI(data: [WinePreviewResponse]) {
        DispatchQueue.main.async {
            self.wineResults = data.map { data in
                WishResultModel(wineId: data.wineId, imageUrl: data.imageUrl, wineName: data.name, sort: data.sort, price: data.price, vivinoRating: data.vivinoRating)
            }
            self.view.hideBlockingView()
            self.noWineLabel.isHidden = !self.wineResults.isEmpty
            self.searchResultTableView.reloadData()
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
        logCellClick(screenName: screenName, indexPath: indexPath, cellName: Tracking.CellEvent.searchWineCellTapped, fileName: #file, cellID: "SearchResultTableViewCell")
        let vc = WineDetailViewController()
        vc.wineId = wineResults[indexPath.row].wineId
        vc.wineName = wineResults[indexPath.row].wineName
        navigationController?.pushViewController(vc, animated: true)
    }
}
