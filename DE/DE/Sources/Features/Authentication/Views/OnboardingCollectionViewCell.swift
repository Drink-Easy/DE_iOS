// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule
import DesignSystem

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
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
        addSubviews(imageView, titleLabel, despLabel)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-Constants.superViewHeight * 0.1)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.superViewHeight * 0.6)
            make.leading.equalTo(DynamicPadding.dynamicValue(32.0))
        }
        
        despLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(DynamicPadding.dynamicValue(18.0))
            make.leading.equalTo(DynamicPadding.dynamicValue(32.0))
        }
    }
    
    func configure(imageName: String, titleText: String, despText: String) {
        imageView.image = UIImage(named: imageName)
        titleLabel.attributedText = .pretendard(titleText, font: .bold, size: 34, lineHeightMultiple: 1.4, letterSpacingPercent: -2.5, color: .white, alignment: .left)
        AppTextStyle.KR.body1.apply(to: despLabel, text: despText, color: .white)
    }
    
}
