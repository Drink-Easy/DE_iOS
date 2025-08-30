// Copyright © 2025 DRINKIG. All rights reserved

import DesignSystem
import UIKit
import SnapKit
import Then

final class YearPickerView: UIView {
    public var minYear: Int
    public var maxYear: Int

    public var onYearSelected: ((Int) -> Void)?
    public var onLabelTapped: (() -> Void)?

    public private(set) var selectedYear: Int? {
        didSet {
            if let year = selectedYear {
                selectedYearLabel.textColor = AppColor.black
                selectedYearLabel.text = "\(year)"
                onYearSelected?(year)
            } else {
                selectedYearLabel.text = "빈티지 선택"
            }
        }
    }

    private let selectedYearLabel = UILabel()
    private let containerView = UIView()
    private let arrowImage = UIImageView()

    init(
        minYear: Int = 1970,
        maxYear: Int = Calendar.current.component(.year, from: Date()),
        defaultYear: Int? = nil
    ) {
        self.minYear = minYear
        self.maxYear = maxYear
        let current = Calendar.current.component(.year, from: Date())
        self.selectedYear = defaultYear ?? current
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        self.minYear = 1970
        self.maxYear = Calendar.current.component(.year, from: Date())
        self.selectedYear = Calendar.current.component(.year, from: Date())
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        containerView.do {
            $0.backgroundColor = AppColor.background
            $0.layer.borderColor = AppColor.gray50.cgColor
            $0.layer.borderWidth = 1
            $0.layer.cornerRadius = 8
            $0.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
            $0.addGestureRecognizer(tap)
        }

        AppTextStyle.KR.body3
            .apply(
                to: selectedYearLabel,
                text: "빈티지 선택",
                color: AppColor.gray70
            )
        
        arrowImage.do {
            $0.image = UIImage(systemName: "chevron.down")
            $0.tintColor = AppColor.gray70
            $0.contentMode = .scaleAspectFit
        }
        
        containerView.addSubviews(selectedYearLabel, arrowImage)
        addSubview(containerView)

        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        selectedYearLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.bottom.equalToSuperview().inset(13.5)
            $0.width.equalTo(198)
        }
        
        arrowImage.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(20)
        }
        
    }
    
    private func updateLabel() {
        selectedYearLabel.text = selectedYear.map { "\($0)" } ?? "빈티지 선택"
    }

    @objc private func labelTapped() {
        onLabelTapped?()
    }

    public func setSelectedYear(_ year: Int) {
        guard (minYear...maxYear).contains(year) else { return }
        selectedYear = year
    }
    
    public func updatePickerView(isModalOpen: Bool) {
        if isModalOpen {
            containerView.layer.borderColor = AppColor.gray100.cgColor
            arrowImage.image = UIImage(systemName: "chevron.up")
        } else {
            containerView.layer.borderColor = AppColor.gray50.cgColor
            arrowImage.image = UIImage(systemName: "chevron.down")
        }
    }

}
