// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import CoreModule

public class WineInfoViewController: UIViewController {

    let wineInfoView = WineInfoView()
    
    let navigationBarManager = NavigationBarManager()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    func setupUI() {
        view.addSubview(wineInfoView)
        wineInfoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
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
