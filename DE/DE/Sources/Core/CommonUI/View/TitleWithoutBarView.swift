// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import DesignSystem

public class TitleWithoutBarView: UIView {
    private let titleLabel = UILabel().then {
        $0.font = UIFont.pretendard(.semiBold, size: 20)
        $0.textColor = AppColor.black
    }

    private let subTitleLabel = UILabel().then {
        $0.font = UIFont.pretendard(.regular, size: 14)
        $0.textColor = AppColor.gray70
    }

    public init(title: String, subTitle: String) {
        super.init(frame: .zero)
        backgroundColor = .clear
        setupView()
        setupConstraints()

        titleLabel.text = title
        subTitleLabel.text = subTitle
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
            $0.leading.equalTo(titleLabel.snp.trailing).offset(6)
            $0.top.bottom.equalToSuperview()
        }
    }
}
