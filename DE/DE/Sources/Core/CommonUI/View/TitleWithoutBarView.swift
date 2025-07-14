// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import DesignSystem

public class TitleWithoutBarView: UIView {
    private let titleLabel = UILabel()

    private let subTitleLabel = UILabel()

    public init(title: String, subTitle: String) {
        super.init(frame: .zero)
        backgroundColor = .clear
        setupView()
        AppTextStyle.KR.subtitle1.apply(to: titleLabel, text: title, color: AppColor.gray100)
        AppTextStyle.KR.caption1.apply(to: subTitleLabel, text: subTitle, color: AppColor.gray90)
        
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        [titleLabel, subTitleLabel].forEach{ self.addSubview($0) }
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
        }

        subTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.trailing).offset(7)
            $0.centerY.equalToSuperview()
        }
    }
    
    public func setTitleColor(_ color: UIColor = AppColor.black) {
        titleLabel.textColor = color
    }
    
    public func setSubTitleColor(_ color: UIColor = AppColor.black) {
        subTitleLabel.textColor = color
    }
}
