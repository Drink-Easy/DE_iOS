// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network

class MyOwnedWineViewController: UIViewController, FirebaseTrackable {
    var screenName: String = Tracking.VC.myWineVC
    
    private let navigationBarManager = NavigationBarManager()
    private let networkService = MyWineService()
    var wineResults: [MyWineViewModel] = []
    
    private lazy var myWineTableView = UITableView().then {
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
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        setNavBarAppearance(navigationController: self.navigationController)
        callGetAPI()
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
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.createBtnTapped, fileName: #file)
        let vc = AddNewWineViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func addComponents() {
        [myWineTableView, noWineLabel].forEach { view.addSubview($0) }
    }
    
    private func setConstraints() {
        myWineTableView.snp.makeConstraints { make in
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
    /// API 호출
    func callGetAPI() {
        Task {
            do {
                let data = try await networkService.fetchAllMyWines()
                wineResults.removeAll()
                
                if let responseData = data {
                    responseData.forEach { wine in
                        let usingWine = MyWineViewModel(myWineId: wine.myWineId,wineId: wine.wineId, wineName: wine.wineName, wineSort: wine.wineSort, wineCountry: wine.wineCountry, wineRegion: wine.wineRegion, wineVariety: wine.wineVariety, wineImageUrl: wine.wineImageUrl, purchaseDate: wine.purchaseDate, purchasePrice: wine.purchasePrice, period: wine.period)
                        
                        wineResults.append(usingWine)
                    }
                }
                DispatchQueue.main.async {
                    self.updateUI()
                }
            } catch {
                print("❌ API 호출 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func updateUI() {
        // Dday(기간) 기준으로 오름차순 정렬
        wineResults.sort { $0.period < $1.period }
        noWineLabel.isHidden = !wineResults.isEmpty
        myWineTableView.reloadData()
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
    
    // TODO : 와인 삭제 api 점검
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
