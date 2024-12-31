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
    
    func configure(
            systemName: String,
            labelText: String,
            iconSize: CGFloat,
            fontSize: CGFloat = 14,
            color: UIColor = AppColor.black ?? .black // 색상 기본값
        ) {
            // 아이콘 이미지 설정
            if let image = UIImage(systemName: systemName)?.withRenderingMode(.alwaysTemplate) {
                iconView.image = image
                iconView.tintColor = color // 아이콘 색상 설정
            }
            
            // 텍스트 설정
            descriptionLabel.text = labelText
            descriptionLabel.font = UIFont.ptdSemiBoldFont(ofSize: fontSize)
            descriptionLabel.textColor = color // 레이블 색상 설정
            
            // 아이콘 크기 동적 설정
            iconView.snp.updateConstraints { make in
                make.size.equalTo(iconSize)
            }
        }
    
    private func setupUI() {
        addSubview(iconView)
        addSubview(descriptionLabel)
        
        iconView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.size.equalTo(10) // 아이콘 크기 설정
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconView.snp.trailing).offset(4)
            make.centerY.equalTo(iconView)
            make.trailing.equalToSuperview()
        }
    }
}
