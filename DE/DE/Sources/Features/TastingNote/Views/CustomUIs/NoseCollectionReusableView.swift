// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

class NoseCollectionReusableView: UICollectionReusableView {
    
    static let identifer = "NoseCollectionReusableView"
    
    let titleLabel: UILabel = {
        let t = UILabel()
        t.text = ""
        t.textColor = .black
        t.font = .ptdSemiBoldFont(ofSize: 18)
        return t
    }()
    
    let toggle: UIButton = {
        let t = UIButton(type: .system)
        t.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        t.tintColor = UIColor(hex: "#A7A7A7")
        return t
    }()
    
    func setupUI() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        addSubview(toggle)
        toggle.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).offset(6)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.leading.equalTo(titleLabel.snp.trailing).offset(9)
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
