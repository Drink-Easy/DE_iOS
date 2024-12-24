// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import UIKit
import CoreModule

class IconLabelView: UIView {
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.ptdSemiBoldFont(ofSize: 12)
        label.textColor = AppColor.black // HEX 컬러 초기값 설정
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(systemName: String, labelText: String) {
        if let image = UIImage(systemName: systemName)?.withTintColor(AppColor.black ?? .black, renderingMode: .alwaysOriginal) {
            iconView.image = image
        }
        descriptionLabel.text = labelText
    }
    
    private func setupUI() {
        addSubview(iconView)
        addSubview(descriptionLabel)
        
        iconView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.size.equalTo(10) // 아이콘 크기 설정
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(8)
            make.centerY.equalTo(iconView)
            make.trailing.equalToSuperview()
        }
    }
}
