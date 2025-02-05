// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import CoreModule

class HomeTopView: UIView {
    
    public weak var delegate: HomeTopViewDelegate? // 델리게이트 선언
    
    private lazy var icon = UIImageView().then {
        $0.image = UIImage(named: "DGIcon")
        $0.backgroundColor = .clear
    }
    
    private lazy var logo = UIImageView().then {
        $0.image = UIImage(named: "HomeLogo")
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
    }
    
    public lazy var searchBtn = UIButton().then {
        $0.setImage(UIImage(named: "searchBarIcon"), for: .normal)
        $0.backgroundColor = .clear
        $0.tintColor = AppColor.gray70
        $0.addTarget(self, action: #selector(didTapSearchButton), for: .touchUpInside)
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
            $0.top.equalTo(safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(10.0))
            $0.leading.equalTo(safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(26.0))
            $0.width.height.equalTo(DynamicPadding.dynamicValue(39.0))
            $0.bottom.equalToSuperview().inset(DynamicPadding.dynamicValue(8.0))
        }
        
        logo.snp.makeConstraints {
            $0.centerY.equalTo(icon)
            $0.leading.equalTo(icon.snp.trailing).offset(DynamicPadding.dynamicValue(10.0))
            $0.width.equalTo(DynamicPadding.dynamicValue(74))
        }
        
        searchBtn.snp.makeConstraints {
            $0.centerY.equalTo(logo)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-DynamicPadding.dynamicValue(24.0))
            $0.width.height.equalTo(DynamicPadding.dynamicValue(24))
        }
    }
    
    @objc private func didTapSearchButton() {
        delegate?.didTapSearchButton()
    }
}

protocol HomeTopViewDelegate: AnyObject {
    func didTapSearchButton()
}
