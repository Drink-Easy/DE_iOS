// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import CoreModule
import Network
import Then

class MorePopularWineViewController: UIViewController {

    let navigationBarManager = NavigationBarManager()
    let wineDataManger = WineDataManager.shared
    let networkService = WineService()
    
    private var wineList: [WineData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        self.view = morePopularWineView
        
        setupNavigationBar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        fetchWineData()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private lazy var morePopularWineView = MoreRecomWineView().then {
        $0.title.text = "지금 가장 인기있는 와인 🔥"
        
        $0.moreWineTableView.dataSource = self
        $0.moreWineTableView.delegate = self
    }
    
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
    
    private func fetchWineData() {
        Task {
            guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
                print("⚠️ userId가 UserDefaults에 없습니다.")
                return
            }
            do {
                // 1. 캐시 데이터 우선 사용
                wineList = try WineDataManager.shared.fetchWineDataList(userId: userId, wineListType: .popular)
                if !wineList.isEmpty {
                    print("✅ 캐시된 데이터 사용: \(wineList.count)개")
                    self.morePopularWineView.moreWineTableView.reloadData()
                    return
                }
            } catch {
                print("⚠️ 캐시된 데이터 없음")
            }
            
            // 2. 캐시 데이터가 없으면 네트워크 요청
            print("🌐 네트워크 요청 시작")
            await fetchWinesFromNetwork(type: .popular)
            self.morePopularWineView.moreWineTableView.reloadData()
        }
        
    }
    
    // MARK: - 네트워크 요청 처리
    private func fetchWinesFromNetwork(type: WineListType) async {
        let fetchFunction: (@escaping (Result<([HomeWineDTO], TimeInterval?), NetworkError>) -> Void) -> Void

        switch type {
        case .recommended:
            fetchFunction = networkService.fetchRecommendWines
        case .popular:
            fetchFunction = networkService.fetchPopularWines
        }

        await withCheckedContinuation { continuation in
            fetchFunction { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let responseData):
                    Task {
                        await self.processWineData(type: type, responseData: responseData.0, time: responseData.1 ?? 3600)
                        continuation.resume()
                    }
                case .failure(let error):
                    print("❌ 네트워크 오류 발생: \(error.localizedDescription)")
                    continuation.resume()
                }
            }
        }
    }
    
    private func processWineData(type: WineListType, responseData: [HomeWineDTO], time: TimeInterval) async {
        let wines = responseData.map {
            WineData(wineId: $0.wineId,
                     imageUrl: $0.imageUrl,
                     wineName: $0.wineName,
                     sort: $0.sort,
                     price: $0.price,
                     vivinoRating: $0.vivinoRating)
        }
        
        do {
            guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
                print("⚠️ userId가 UserDefaults에 없습니다.")
                return
            }
            try await WineDataManager.shared.saveWineData(userId: userId, wineListType: type, wineData: wines, expirationInterval: time)
        } catch {
            print("❌ 데이터 저장 중 오류 발생: \(error)")
        }
    }
}

extension MorePopularWineViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wineList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MoreWineTableViewCell", for: indexPath) as? MoreWineTableViewCell else {
            return UITableViewCell()
        }
        
        let wine = wineList[indexPath.row]
        cell.configure(model: wine)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = WineDetailViewController()
        vc.wineId = wineList[indexPath.row].wineId
        navigationController?.pushViewController(vc, animated: true)
    }
}
