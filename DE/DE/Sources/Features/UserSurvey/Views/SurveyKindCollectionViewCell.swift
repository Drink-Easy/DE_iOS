// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import DesignSystem
import Then
import SnapKit

class SurveyKindCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SurveyKindCollectionViewCell"
    
    private lazy var contents = UILabel().then {
        $0.textColor = AppColor.gray90
        $0.font = UIFont.pretendard(.medium, size: 16)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = AppColor.gray10
        contentView.layer.cornerRadius = DynamicPadding.dynamicValue(24.5)
        contentView.layer.masksToBounds = true
        addComponents()
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        [contents].forEach{ contentView.addSubview($0) }
    }
    
    private func constraints() {
        contents.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
    
    public func configure(contents: String) {
        self.contents.text = contents
    }
    
    func updateAppearance(isSelected: Bool) {
        contentView.layer.borderWidth = isSelected ? 1 : 0
        contentView.layer.borderColor = isSelected ? AppColor.purple70.cgColor : AppColor.gray10.cgColor
        contentView.backgroundColor = isSelected ? AppColor.purple10 : AppColor.gray10
        contents.textColor = isSelected ? AppColor.purple100 : AppColor.gray90
        contents.font = isSelected ? UIFont.pretendard(.semiBold, size: 16) : UIFont.pretendard(.medium, size: 16)
    }
}
