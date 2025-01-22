// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import CoreModule
import Network
import Then

class MoreLikelyWineViewController: UIViewController {

    let navigationBarManager = NavigationBarManager()
    let userDataManager = UserDataManager.shared
    let wineDataManger = WineDataManager.shared
    let networkService = WineService()
    
    public var userName: String = "" {
        didSet {
            updateLikeWineListView()
        }
    }
    private var wineList: [WineData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        self.view = moreLikelyWineView
        self.moreLikelyWineView.title.setPartialTextStyle(text: moreLikelyWineView.title.text ?? "", targetText: "\(userName)", color: AppColor.purple100 ?? .purple, font: UIFont.ptdSemiBoldFont(ofSize: 30))
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
    
    private func fetchWineData() {
        Task {
            guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
                print("⚠️ userId가 UserDefaults에 없습니다.")
                return
            }
            do {
                // 1. 캐시 데이터 우선 사용
                wineList = try WineDataManager.shared.fetchWineDataList(userId: userId, wineListType: .recommended)
                if !wineList.isEmpty {
                    print("✅ 캐시된 데이터 사용: \(wineList.count)개")
                    print(wineList[0].wineName)
                    self.moreLikelyWineView.moreWineTableView.reloadData()
                    return
                }
            } catch {
                print("⚠️ 캐시된 데이터 없음")
            }
            
            // 2. 캐시 데이터가 없으면 네트워크 요청
            print("🌐 네트워크 요청 시작")
            await fetchWinesFromNetwork(type: .recommended)
            self.moreLikelyWineView.moreWineTableView.reloadData()
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
    
    private lazy var moreLikelyWineView = MoreRecomWineView().then {
        $0.title.text = "\(userName) 님을 위한 추천 와인"
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
    
    private func updateLikeWineListView() {
        moreLikelyWineView.title.text = "\(userName) 님을 위한 추천 와인"
        moreLikelyWineView.title.setPartialTextStyle(
            text: moreLikelyWineView.title.text ?? "",
            targetText: "\(userName)",
            color: AppColor.purple100 ?? .purple,
            font: UIFont.ptdSemiBoldFont(ofSize: 30)
        )
    }
}

extension MoreLikelyWineViewController: UITableViewDelegate, UITableViewDataSource {
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
        let vc = HomeWineDetailViewController()
        vc.wineId = wineList[indexPath.row].wineId
        navigationController?.pushViewController(vc, animated: true)
    }
}
