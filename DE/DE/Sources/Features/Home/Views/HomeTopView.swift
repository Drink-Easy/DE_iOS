// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import CoreModule

class HomeTopView: UIView {
    
    private lazy var icon = UIImageView().then {
        $0.image = UIImage(named: "DGIcon")
        $0.backgroundColor = .clear
    }
    
    private lazy var logo = UIImageView().then {
        $0.image = UIImage(named: "HomeLogo")
        $0.backgroundColor = .clear
    }
    
    public lazy var searchBtn = UIButton().then {
        $0.setImage(UIImage(named: "searchBarIcon"), for: .normal)
        $0.backgroundColor = .clear
        $0.tintColor = UIColor(hex: "#767676")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColor.bgGray
        self.addComponents()
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addComponents() {
        [icon, logo, searchBtn].forEach{ self.addSubview($0) }
    }
    
    private func constraints() {
        icon.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(10)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(26)
            $0.width.height.equalTo(39)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        logo.snp.makeConstraints {
            $0.centerY.equalTo(icon)
            $0.leading.equalTo(icon.snp.trailing).offset(10)
        }
        
        searchBtn.snp.makeConstraints {
            $0.centerY.equalTo(logo)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-24)
        }
    }
}
