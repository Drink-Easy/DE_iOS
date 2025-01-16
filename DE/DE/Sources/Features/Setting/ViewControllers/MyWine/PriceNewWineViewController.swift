// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import SnapKit
import Then
// TODO : 도연
// TODO : 디테일 수정
// 버튼 활성화 기능 등 추가
// 기능 작업 더 해야함.

class PriceNewWineViewController: UIViewController {

    let priceNewWineView = PriceNewWineView()
    let navigationBarManager = NavigationBarManager()
    public var selectDate : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupNavigationBar()
    }
    
    func setupUI() {
        priceNewWineView.setWineName("와인이름데이터넘겨주기")
        view.addSubview(priceNewWineView)
        priceNewWineView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        navigationBarManager.setTitle(to: navigationItem, title: "", textColor: AppColor.black!)
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: AppColor.gray80!
        )
    }
    
    func setupActions() {
        priceNewWineView.nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
    }
    
    @objc func nextVC() {
        
        //        let nextVC = ChooseWineColorViewController()
        let nextVC = TestVC()
        
//        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }

}
