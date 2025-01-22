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
    
    let wineName = UserDefaults.standard.string(forKey: "wineName")
    
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
        header.setTitleLabel(wineName ?? "와인이에용")
        wineDetailView.setEditButton(showEditButton: true)
        wineDetailView.editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        setWineDetailInfo() //TODO: api 연결 후 지우기
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
        wineDetailView.items = [("구매 가격", "100원"),
                                ("구매일 D+1", "1998-12-29")]
        
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func editButtonTapped() {
        let nextVC = RatingWineViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
