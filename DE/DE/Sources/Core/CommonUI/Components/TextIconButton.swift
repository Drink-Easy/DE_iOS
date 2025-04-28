// Copyright © 2025 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import DesignSystem

public final class TextIconButton: UIControl {

    private let label = UILabel().then {
        $0.textColor = AppColor.gray50
        $0.font = UIFont.pretendard(.medium, size: 12)
        $0.numberOfLines = 1
    }

    private let icon = UIImageView().then {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .regular)
        let image = UIImage(systemName: "chevron.forward", withConfiguration: symbolConfig)?
            .withRenderingMode(.alwaysTemplate)
        $0.image = image
        $0.tintColor = AppColor.gray50
        $0.contentMode = .scaleAspectFit
    }

    // MARK: - Init
    public init(title: String) {
        super.init(frame: .zero)
        label.text = title
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }

    // MARK: - UI Setup
    private func setupUI() {
        backgroundColor = .clear
        self.addSubviews(label, icon)
    }

    private func setupConstraints() {
        label.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
        }

        icon.snp.makeConstraints {
            $0.leading.equalTo(label.snp.trailing).offset(6)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }

    // MARK: - Public
    public func setText(_ text: String) {
        label.text = text
    }
}
