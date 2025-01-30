// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule
import Network

public class MyOwnedWineInfoViewController: UIViewController {
    
    let navigationBarManager = NavigationBarManager()
    
    //MARK: UI Elements
    private lazy var header = MyNoteTopView()
    private lazy var wineDetailView = SimpleListView()
    
    var registerWine: MyWineViewModel?
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        wineDetailView.editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    private func setWineData() {
        guard let currentWine = self.registerWine else { return }
        header.setTitleLabel(currentWine.wineName)
        header.infoView.image.sd_setImage(with: URL(string: currentWine.wineImageUrl))
        header.infoView.typeContents.text = "\(currentWine.wineCountry), \(currentWine.wineRegion)"
        header.infoView.countryContents.text = currentWine.wineVariety
        header.infoView.kindContents.text = currentWine.wineSort
        
        self.setWineDetailInfo(currentWine)
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = AppColor.bgGray
        [header, wineDetailView].forEach{
            view.addSubview($0)
        }
        header.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
            make.height.greaterThanOrEqualTo(180)
        }
        wineDetailView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(DynamicPadding.dynamicValue(36))
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
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
        wineDetailView.items = [("구매 가격", "\(priceString)원"),
                                ("구매일 D+\(registerWine.period)", "\(registerWine.purchaseDate)")]
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func editButtonTapped() {
        guard let currentWine = self.registerWine else { return }
        
        let nextVC = ChangeMyOwnedWineViewController()
        nextVC.registerWine = MyOwnedWine(wineId: currentWine.wineId, wineName: currentWine.wineName, price: String(currentWine.purchasePrice), buyDate: currentWine.purchaseDate)
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
