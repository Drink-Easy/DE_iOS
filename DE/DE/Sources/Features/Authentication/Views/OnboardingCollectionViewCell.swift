// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }
    
    private let label1 = UILabel().then {
        $0.font = UIFont.ptdBoldFont(ofSize: 33)
        $0.textColor = .white
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let label2 = UILabel().then {
        $0.font = UIFont.ptdMediumFont(ofSize: 14)
        $0.textColor = .white
        $0.textAlignment = .center
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
        [imageView, label1, label2].forEach { addSubview($0) }
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-Constants.superViewHeight * 0.1)
            make.leading.trailing.bottom.equalToSuperview()
        }
        label1.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.superViewHeight * 0.6)
            make.leading.equalTo(DynamicPadding.dynamicValue(32.0))
        }
        label2.snp.makeConstraints { make in
            make.top.equalTo(label1.snp.bottom).offset(20)
            make.leading.equalTo(DynamicPadding.dynamicValue(32.0))
        }
    }
    
    func configure(imageName: String, label1: String, label2: String) {
        imageView.image = UIImage(named: imageName)
        self.label1.text = label1
        self.label2.text = label2
    }
}
