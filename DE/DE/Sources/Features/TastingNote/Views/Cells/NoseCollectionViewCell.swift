// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import DesignSystem

class NoseCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NoseCollectionViewCell"
    
    let menuView: UIView = {
        let m = UIView()
        m.backgroundColor = AppColor.gray10
        m.layer.cornerRadius = 20
        m.layer.borderWidth = 1
        m.layer.borderColor = UIColor.clear.cgColor
        return m
    }()
    
    let menuLabel: UILabel = {
        let m = UILabel()
        m.text = ""
        m.textColor = AppColor.gray100
        m.font = UIFont.pretendard(.medium, size: 14)
        m.textAlignment = .center
        return m
    }()
    
    private func setupUI() {
        addSubview(menuView)
        menuView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        menuView.frame = bounds
        
        menuView.addSubview(menuLabel)
        menuLabel.snp.makeConstraints { make in
            make.leading.equalTo(menuView.snp.leading).offset(15)
            make.top.equalTo(menuView.snp.top).offset(12)
            make.centerX.equalTo(menuView.snp.centerX)
            make.centerY.equalTo(menuView.snp.centerY)
        }
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
