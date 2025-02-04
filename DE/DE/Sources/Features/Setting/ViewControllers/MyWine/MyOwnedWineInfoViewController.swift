// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule
import Network

public class MyOwnedWineInfoViewController: UIViewController {
    
    let navigationBarManager = NavigationBarManager()
    let networkService = MyWineService()
    
    //MARK: UI Elements
    private lazy var header = MyNoteTopView()
    private lazy var wineDetailView = SimpleListView()
    public lazy var deleteButton = CustomButton(title: "다 마셨어요", isEnabled: true)
    
    var registerWine: MyWineViewModel?
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setWineData()
        wineDetailView.setEditButton(showEditButton: true)
    }
    
    private func setWineData() {
        guard let currentWine = self.registerWine else { return }
        header.setTitleLabel(currentWine.wineName)
        header.infoView.image.sd_setImage(with: URL(string: currentWine.wineImageUrl), placeholderImage: UIImage(named: "placeholder"))
        header.infoView.typeContents.text = "\(currentWine.wineCountry), \(currentWine.wineRegion)"
        header.infoView.countryContents.text = currentWine.wineVariety
        header.infoView.kindContents.text = currentWine.wineSort
        
        self.setWineDetailInfo(currentWine)
        wineDetailView.editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = AppColor.bgGray
        [header, wineDetailView, deleteButton].forEach{
            view.addSubview($0)
        }
        
        header.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
            make.height.greaterThanOrEqualTo(180)
        }
        
        wineDetailView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(DynamicPadding.dynamicValue(36))
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
            make.height.equalTo(100)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(DynamicPadding.dynamicValue(40))
        }
    }
    
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC)
        )
    }
    
    private func setWineDetailInfo(_ registerWine: MyWineViewModel) {
        let priceString = formatPrice(registerWine.purchasePrice)
        wineDetailView.titleLabel.text = "구매 정보"
        if registerWine.period >= 0 {
            wineDetailView.items = [("구매 가격", "\(priceString)원"),
                                    ("구매일 D+\(registerWine.period+1)", "\(registerWine.purchaseDate)")]
        } else {
            wineDetailView.items = [("구매 가격", "\(priceString)원"),
                                    ("구매일 D\(registerWine.period)", "\(registerWine.purchaseDate)")]
        }
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func editButtonTapped() {
        guard let currentWine = self.registerWine else { return }
        
        let nextVC = ChangeMyOwnedWineViewController()
        nextVC.registerWine = currentWine
        
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func deleteButtonTapped() {
        guard let currentWine = self.registerWine else { return }
        
        let alert = UIAlertController(
            title: "이 와인을 삭제하시겠습니까?",
            message: "\(currentWine.wineName)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
            self?.callDeleteAPI()
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func callDeleteAPI() {
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
            print("⚠️ userId가 UserDefaults에 없습니다.")
            return
        }
        
        Task {
            do {
                _ = try await networkService.deleteMyWine(myWineId: registerWine!.wineId)
                try await APICallCounterManager.shared.createAPIControllerCounter(for: userId, controllerName: .myWine)
                try await APICallCounterManager.shared.incrementDelete(for: userId, controllerName: .myWine)
            } catch {
                print("\(error)\n 잠시후 다시 시도해주세요.")
            }
        }
    }
}
