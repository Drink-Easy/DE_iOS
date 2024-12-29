// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit

class WineInfoViewController: UIViewController {

    let wineInfoView = WineInfoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(wineInfoView)
        wineInfoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
