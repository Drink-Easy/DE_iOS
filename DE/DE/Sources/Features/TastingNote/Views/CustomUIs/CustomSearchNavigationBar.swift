// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

class CustomSearchNavigationBar: UIView {
    
    let searchButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        b.tintColor = AppColor.gray60
        return b
    }()
    
    func setupUI() {
        addSubview(searchButton)
        searchButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24)
            make.top.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
