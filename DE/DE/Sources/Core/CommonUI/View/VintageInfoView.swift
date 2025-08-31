// Copyright © 2025 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then
import DesignSystem

public class VintageInfoView: UIView {
    public var tabAction: (() -> Void)?

    private let title = TitleWithoutBarView(title: "Vintages", subTitle: "빈티지")

    private let yearLabel = UILabel()

    private let arrowImageView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = AppColor.gray70
        $0.contentMode = .scaleAspectFit
    }

    public lazy var vintageChangeView: UIView = UIView().then {
        $0.backgroundColor = AppColor.white
        $0.layer.cornerRadius = 5
        $0.layer.shadowColor = UIColor(hex: "111111")?.cgColor
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.layer.shadowRadius = 5
        $0.layer.masksToBounds = false

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        $0.addGestureRecognizer(tap)

        $0.addSubview(yearLabel)
        $0.addSubview(arrowImageView)

        yearLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }

        arrowImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(24)
        }

        $0.snp.makeConstraints {
            $0.height.equalTo(50)
        }
    }

    public init() {
        super.init(frame: .zero)
        setupLayout()
        configure(with: "빈티지 선택")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubviews(title, vintageChangeView)

        title.snp.makeConstraints {
            $0.top.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }

        vintageChangeView.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(10)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }
    }

    @objc private func handleTap() {
        tabAction?()
    }

    public func configure(with yearText: String) {
        AppTextStyle.KR.body1.apply(to: yearLabel,
                                    text: yearText,
                                    color: AppColor.gray100,
                                    alignment: .left)
    }
}
