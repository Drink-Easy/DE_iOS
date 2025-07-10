// Copyright © 2025 DRINKIG. All rights reserved

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
                selectedYearLabel.text = "선택된 연도: \(year)"
                onYearSelected?(year)
            } else {
                selectedYearLabel.text = "선택된 연도: -"
            }
        }
    }

    private let selectedYearLabel = UILabel()

    init(minYear: Int = 1970, maxYear: Int = 2100, defaultYear: Int? = nil) {
        self.minYear = minYear
        self.maxYear = maxYear
        let current = Calendar.current.component(.year, from: Date())
        self.selectedYear = defaultYear ?? current
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        self.minYear = 1970
        self.maxYear = 2100
        self.selectedYear = Calendar.current.component(.year, from: Date())
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        selectedYearLabel.do {
            $0.textAlignment = .center
            $0.font = .pretendard(.regular, size: 18)
            $0.text = "빈티지 연도를 선택해주세요."
            $0.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
            $0.addGestureRecognizer(tap)
        }

        addSubview(selectedYearLabel)
        selectedYearLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func updateLabel() {
        selectedYearLabel.text = selectedYear.map { "선택된 연도: \($0)" } ?? "선택된 연도: -"
    }

    @objc private func labelTapped() {
        onLabelTapped?()
    }

    public func setSelectedYear(_ year: Int) {
        guard (minYear...maxYear).contains(year) else { return }
        selectedYear = year
    }

}
