// Copyright © 2025 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then

final class YearPickerView: UIView {
    public var minYear: Int
    public var maxYear: Int

    public var onYearSelected: ((Int) -> Void)?

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


    private var years: [Int] = []

    private let pickerView = UIPickerView()
    private let selectedYearLabel = UILabel()

    init(minYear: Int = 1970, maxYear: Int = 2100, defaultYear: Int? = nil) {
        self.minYear = minYear
        self.maxYear = maxYear
        let current = Calendar.current.component(.year, from: Date())
        self.selectedYear = defaultYear ?? current
        super.init(frame: .zero)
        configureYears()
        setupUI()
        setDefaultSelection()
    }

    required init?(coder: NSCoder) {
        self.minYear = 1970
        self.maxYear = 2100
        self.selectedYear = Calendar.current.component(.year, from: Date())
        super.init(coder: coder)
        configureYears()
        setupUI()
        setDefaultSelection()
    }

    // MARK: - Setup

    private func configureYears() {
        years = Array(minYear...maxYear)
    }

    private func setupUI() {
        pickerView.do {
            $0.dataSource = self
            $0.delegate = self
        }

        selectedYearLabel.do {
            $0.textAlignment = .center
            $0.font = .systemFont(ofSize: 18, weight: .medium)
        }

        let stack = UIStackView(arrangedSubviews: [pickerView, selectedYearLabel]).then {
            $0.axis = .vertical
            $0.spacing = 16
            $0.alignment = .fill
            $0.distribution = .fill
        }

        addSubview(stack)
        stack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setDefaultSelection() {
        selectedYear = nil
    }
}

extension YearPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        years.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "\(years[row])년"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedYear = years[row]
    }
}
