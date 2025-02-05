// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network

class MyOwnedWineViewController: UIViewController {
    
    private let navigationBarManager = NavigationBarManager()
    
    private let networkService = MyWineService()
    var wineResults: [MyWineViewModel] = []
    
    private lazy var myWienTableView = UITableView().then {
        $0.register(MyWineTableViewCell.self, forCellReuseIdentifier: MyWineTableViewCell.identifier)
        $0.separatorInset = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        $0.backgroundColor = AppColor.grayBG
        $0.dataSource = self
        $0.delegate = self
        $0.showsVerticalScrollIndicator = false
    }
    
    private lazy var noWineLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.text = "보유 와인에 담긴 와인이 없어요.\n구매한 와인을 직접 등록하고\n관리해 보세요!"
        $0.setLineSpacingPercentage(0.3)
        $0.font = UIFont.ptdRegularFont(ofSize: 14)
        $0.textColor = AppColor.gray70
        $0.textAlignment = .center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        setupNavigationBar()
        addComponents()
        setConstraints()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        CheckCacheData()
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        setNavBarAppearance(navigationController: self.navigationController)
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
            title: "보유와인",
            textColor: AppColor.black ?? .black
        )
        
        navigationBarManager.addRightButton(
            to: navigationItem,
            icon: "plus",
            target: self,
            action: #selector(addNewWine),
            tintColor: AppColor.gray70!
        )
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func addNewWine() {
        let vc = AddNewWineViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func addComponents() {
        [myWienTableView, noWineLabel].forEach { view.addSubview($0) }
    }

    private func setConstraints() {
        myWienTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(11.0))
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(DynamicPadding.dynamicValue(18.0))
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(651)
        }
        
        noWineLabel.snp.makeConstraints {
            $0.centerX.centerY.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    //MARK: - API calls
    private func CheckCacheData() {
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
            print("⚠️ userId가 UserDefaults에 없습니다.")
            return
        }
        
        Task {
            do {
                if try await APICallCounterManager.shared.isCallCountZero(for: userId, controllerName: .myWine) {
                    print("✅ 캐시 데이터 사용 가능")
                    await useCacheData(for: userId)
                } else {
                    await callGetAPI(for: userId)
                }
            } catch {
                print("⚠️ 캐시 데이터 검증 실패: \(error)")
                await callGetAPI(for: userId)
            }
        }
    }
    
    func validateWineData(wine: MyWineResponse) {
        print("🔍 [데이터 검증 시작] wineId: \(wine.wineId)")

        // `nil` 또는 빈 값 체크
        let fieldsToCheck: [(String, Any?)] = [
            ("myWineId", wine.myWineId),
            ("wineId", wine.wineId),
            ("wineName", wine.wineName),
            ("wineSort", wine.wineSort),
            ("wineCountry", wine.wineCountry),
            ("wineRegion", wine.wineRegion),
            ("wineVariety", wine.wineVariety),
            ("wineImageUrl", wine.wineImageUrl),
            ("purchaseDate", wine.purchaseDate),
            ("purchasePrice", wine.purchasePrice),
            ("period", wine.period)
        ]

        for (key, value) in fieldsToCheck {
            if let strValue = value as? String, strValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                print("🚨 [경고] \(key) 값이 공백입니다.")
            } else if value == nil {
                print("🚨 [경고] \(key) 값이 nil입니다.")
            }
        }
        
        print("✅ [데이터 검증 완료] wineId: \(wine.wineId)\n")
    }
    
    /// API 호출
    @MainActor
    func callGetAPI(for userId: Int) async {
        do {
            let data = try await networkService.fetchAllMyWines()
            wineResults.removeAll()
            var savedList: [SavedWineDataModel] = []
            
            data?.forEach { wine in
                validateWineData(wine: wine)
                let usingWine = MyWineViewModel(myWineId: wine.myWineId,wineId: wine.wineId, wineName: wine.wineName, wineSort: wine.wineSort, wineCountry: wine.wineCountry, wineRegion: wine.wineRegion, wineVariety: wine.wineVariety, wineImageUrl: wine.wineImageUrl, purchaseDate: wine.purchaseDate, purchasePrice: wine.purchasePrice, period: wine.period)

                let savingWine = SavedWineDataModel(wineId: wine.wineId, myWineId: wine.myWineId, wineName: wine.wineName, imageURL: wine.wineImageUrl, wineSort: wine.wineSort, wineCountry: wine.wineCountry, wineRegion: wine.wineRegion, wineVariety: wine.wineVariety, price: wine.purchasePrice, date: wine.purchaseDate, Dday: wine.period)

                wineResults.append(usingWine)
                savedList.append(savingWine)
            }
            
            self.noWineLabel.isHidden = !savedList.isEmpty

            myWienTableView.reloadData()

            // 🔥 캐시 저장 & 콜카운트 초기화
            do {
                try await MyWineListDataManager.shared.createSavedWineListIfNeeded(for: userId, with: savedList, date: Date()) // 사실상 캐시 정보 업데이트
                try await APICallCounterManager.shared.createAPIControllerCounter(for: userId, controllerName: .myWine)
                try await APICallCounterManager.shared.resetCallCount(for: userId, controllerName: .myWine)
            } catch {
                print("⚠️ 캐시 데이터 저장 실패: \(error)")
            }
        } catch {
            print("❌ API 호출 실패: \(error)")
        }
    }
    
    @MainActor
    private func useCacheData(for userId: Int) async {
        do {
            // ✅ 유효기간 지난 데이터 삭제
            try await MyWineListDataManager.shared.clearExpiredWineList(for: userId)
            
            // ✅ 캐시 데이터 가져오기
            let data = try await MyWineListDataManager.shared.fetchSavedWinelist(for: userId)
            
            // ✅ 데이터 변환 및 저장
            wineResults = data.map {
                MyWineViewModel(myWineId: $0.myWineId, wineId: $0.wineId, wineName: $0.wineName, wineSort: $0.wineSort, wineCountry: $0.wineCountry, wineRegion: $0.wineRegion, wineVariety: $0.wineVariety, wineImageUrl: $0.imageURL, purchaseDate: $0.date, purchasePrice: $0.price, period: $0.Dday)
            }
            DispatchQueue.main.async {
                if self.wineResults.isEmpty || self.wineResults.count == 0 {
                    self.noWineLabel.isHidden = false
                } else {
                    self.noWineLabel.isHidden = true
                }
            }
            myWienTableView.reloadData()
        } catch {
            print("⚠️ 캐시 데이터 가져오기 실패: \(error)")
            await callGetAPI(for: userId) // 캐시 데이터가 없을 경우, 네트워크 API 호출
        }
    }
}

extension MyOwnedWineViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wineResults.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyWineTableViewCell.identifier, for: indexPath) as? MyWineTableViewCell else {
            return UITableViewCell()
        }
        
        let wine = wineResults[indexPath.row]
        cell.configure(model: wine)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let infoVC = MyOwnedWineInfoViewController()
        infoVC.registerWine = wineResults[indexPath.row]
        infoVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(infoVC, animated: true)
    }
    
    //스와이프 시작 시 셀 배경색 변경
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = AppColor.purple10
        }
    }

    // 스와이프 종료 시 셀 배경색 복원
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        if let indexPath = indexPath, let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = AppColor.bgGray
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let wineName = wineResults[indexPath.row].wineName
        
        let deleteAction = UIContextualAction(style: .destructive, title: "") { (action, view, completionHandler) in
            let alert = UIAlertController(title: "이 와인을 삭제하시겠습니까?", message: wineName, preferredStyle: .alert)
            guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
                print("⚠️ userId가 UserDefaults에 없습니다.")
                return
            }
            let deleteConfirmAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                Task {
                    do {
                        // 1️⃣ 서버에서 와인 삭제
                        _ = try await self.networkService.deleteMyWine(myWineId: self.wineResults[indexPath.row].myWineId)
                        
                        // 2️⃣ 삭제 API 호출 성공 후, 콜카운트 증가
                        try await APICallCounterManager.shared.incrementDelete(for: userId, controllerName: .myWine)
                        
                        // 3️⃣ 최신 데이터를 다시 불러오기
                        self.CheckCacheData()
        
                        self.wineResults.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        completionHandler(true)
                        
                        self.noWineLabel.isHidden = !self.wineResults.isEmpty
    
                        
                    } catch {
                        print("❌ 삭제 실패: \(error)")
                        completionHandler(false)
                    }
                }
            }
            
            
            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
                completionHandler(false) // ✅ 스와이프 해제 (셀 원상복귀)
            }
            
            alert.addAction(deleteConfirmAction)
            alert.addAction(cancelAction)
            
            if let topVC = UIApplication.shared.windows.first?.rootViewController {
                topVC.present(alert, animated: true, completion: nil)
            }
        }
        
        // 버튼 색상 설정
        deleteAction.backgroundColor = AppColor.purple100
        deleteAction.image = UIImage(systemName: "trash")

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
