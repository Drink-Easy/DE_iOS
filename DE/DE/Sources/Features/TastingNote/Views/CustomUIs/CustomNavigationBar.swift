// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

class CustomNavigationBar: UIView {
    
    let backButton: UIButton = {
        let b = UIButton()
        b.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        b.tintColor = AppColor.gray60
        return b
    }()
    
    func setupUI() {
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
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
