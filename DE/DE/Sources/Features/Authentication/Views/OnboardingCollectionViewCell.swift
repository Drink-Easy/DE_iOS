// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule
import DesignSystem

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    
    private let despLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = AppColor.background
        addSubviews(imageView, titleLabel, despLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.superViewHeight * 0.15)
            make.width.height.equalTo(Constants.superViewWidth * 0.8)
            make.centerX.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(DynamicPadding.dynamicValue(32))
            make.centerX.equalToSuperview()
        }
        
        despLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(DynamicPadding.dynamicValue(18.0))
            make.centerX.equalToSuperview()
        }
    }
    
    func configure(imageName: String, titleText: String, despText: String) {
        imageView.image = UIImage(named: imageName)
        titleLabel.attributedText = .pretendard(titleText, font: .bold, size: 34, lineHeightMultiple: 1.4, letterSpacingPercent: -2.5, color: AppColor.black, alignment: .left)
        AppTextStyle.KR.body1.apply(to: despLabel, text: despText, color: AppColor.gray100)
    }
    
}
