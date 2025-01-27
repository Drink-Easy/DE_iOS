// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule
import Network

//TODO: api 연결
public class MyOwnedWineInfoViewController: UIViewController {
    
    let navigationBarManager = NavigationBarManager()
    
    //MARK: UI Elements
    private lazy var header = MyNoteTopView()
    private lazy var wineDetailView = SimpleListView()
//    public lazy var nextButton = CustomButton(title: "다 마셨어요!", isEnabled: false)
    
    var registerWine: MyOwnedWine = MyOwnedWine()
    
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
        header.setTitleLabel(registerWine.wineName)
        wineDetailView.setEditButton(showEditButton: true)
        wineDetailView.editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        setWineDetailInfo()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = AppColor.bgGray
        [header, wineDetailView].forEach{
            view.addSubview($0)
        }
        header.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalToSuperview().inset(24)
            make.height.greaterThanOrEqualTo(180)
        }
        wineDetailView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(36)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC)
        )
    }
    
    private func setWineDetailInfo() {
        wineDetailView.titleLabel.text = "구매 정보"
        wineDetailView.items = [("구매 가격", "\(registerWine.price)원"),
                                ("구매일 D+\(registerWine.Dday)", "\(registerWine.buyDate)")]
        
    
        DispatchQueue.main.async {
            let wineService = WineService()
            // 와인 정보 가져오기 TODO
            // 이미지 세팅. 종류 품종 생산지 세팅
        }
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func editButtonTapped() {
        let nextVC = ChangeMyOwnedWineViewController()
        nextVC.registerWine = self.registerWine
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
