// Copyright © 2025 DRINKIG. All rights reserved

import UIKit
import CoreModule
import DesignSystem
import SnapKit
import Then

// 연도 선택기 모달
final class YearPickerModalViewController: UIViewController {
    var minYear: Int
    var maxYear: Int
    var selectedYear: Int?

    var onYearConfirmed: ((Int) -> Void)?

    private var years: [Int] = []
    private let pickerView = UIPickerView()
    public lazy var confirmButton = CustomButton(title: "확인", isEnabled: false)

    init(minYear: Int, maxYear: Int, selectedYear: Int? = nil) {
        self.minYear = minYear
        self.maxYear = maxYear
        self.selectedYear = selectedYear
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .pageSheet
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background
        years = Array(minYear...maxYear)
        setupUI()
    }

    private func setupUI() {
        pickerView.dataSource = self
        pickerView.delegate = self

        if let selected = selectedYear, let index = years.firstIndex(of: selected) {
            pickerView.selectRow(index, inComponent: 0, animated: false)
        }
        
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
        confirmButton.isEnabled(isEnabled: true)

        view.addSubview(pickerView)
        view.addSubview(confirmButton)

        pickerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.leading.trailing.equalToSuperview()
        }

        confirmButton.snp.makeConstraints {
            $0.top.equalTo(pickerView.snp.bottom).offset(DynamicPadding.dynamicValue(20))
            $0.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
            $0.bottom.equalToSuperview().inset(DynamicPadding.dynamicValue(40))
        }
    }

    @objc private func confirmTapped() {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        let selectedYear = years[selectedRow]
        onYearConfirmed?(selectedYear)
        dismiss(animated: true)
    }
}

extension YearPickerModalViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        years.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        "\(years[row])년"
    }
}
