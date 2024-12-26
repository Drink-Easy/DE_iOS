// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import SnapKit
import Then

class ProfileView: UIView {
    
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 40 // 원형 이미지
        $0.image = UIImage(systemName: "person.circle.fill") // 기본 이미지
        $0.tintColor = .gray
    }
    
    private let nameLabel = UILabel().then {
        $0.text = "사용자 이름"
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 16)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    private let menuTableview = UITableView().then {
        $0.separatorStyle = .singleLine
        $0.rowHeight = 50
        $0.showsVerticalScrollIndicator = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // UI 요소 추가
        [profileImageView, nameLabel, menuTableview].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        // 레이아웃 설정
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.superViewHeight * (116/844))
            make.centerX.equalToSuperview()
            make.width.height.equalTo(95)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        menuTableview.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(34)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
}

