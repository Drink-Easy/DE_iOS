// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule
import DesignSystem

class WineColorCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "WineColorCollectionViewCell"

    public lazy var colorView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderColor = UIColor.clear.cgColor
        $0.layer.borderWidth = 3
        $0.layer.cornerRadius = DynamicPadding.dynamicValue(10.0)
        $0.layer.masksToBounds = true
    }
    
    public lazy var checkmark = UIImageView().then {
        $0.image = UIImage(systemName: "checkmark")
        $0.tintColor = .white
        $0.isHidden = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //레이아웃까지
    private func setupUI() {
        self.contentView.addSubview(colorView)
        self.contentView.addSubview(checkmark)
        
        colorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.height.greaterThanOrEqualTo(DynamicPadding.dynamicValue(64.0))
        }
        
        checkmark.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview().inset(20)
        }
    }
    
    func configure(colorhex: UIColor?, isSelected: Bool, isLight: Bool) {
        if isSelected {
            colorView.backgroundColor = colorhex
            colorView.layer.borderColor = isLight ? AppColor.purple100.cgColor : AppColor.purple30.cgColor
            checkmark.tintColor = isLight ? AppColor.purple100 : AppColor.purple30
            checkmark.isHidden = false
        } else {
            colorView.backgroundColor = colorhex
            colorView.layer.borderColor = UIColor.clear.cgColor
            checkmark.isHidden = true
        }
    }
}
