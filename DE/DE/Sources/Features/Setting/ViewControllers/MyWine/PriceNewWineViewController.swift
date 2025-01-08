// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

class PriceNewWineViewController: UIViewController {

    let priceNewWineView = PriceNewWineView()
    let navigationBarManager = NavigationBarManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupNavigationBar()
    }
    
    func setupUI() {
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
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }

}
