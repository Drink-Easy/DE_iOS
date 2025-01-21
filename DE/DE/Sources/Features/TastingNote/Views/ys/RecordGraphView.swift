// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import UIKit
import SnapKit
import Then
import CoreModule

class RecordGraphView: UIView {
    
    // MARK: - UI Elements
    let chartHeaderView = PropertyTitleView(type: .palateGraph)
    let chartView = PolygonChartView()
    let recordSliderView = RecordSliderView()
    
    let nextButton = CustomButton(
        title: "다음",
        titleColor: .white,
        isEnabled: true
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = AppColor.bgGray
        
        
        [chartHeaderView, chartView, recordSliderView, nextButton].forEach {
            addSubview($0)
        }
        
        chartHeaderView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(30)
        }
        
        chartView.snp.makeConstraints { make in
            make.top.equalTo(chartHeaderView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
        }
        
        recordSliderView.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.superViewHeight * 0.5)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(recordSliderView.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func setupSliders(target: Any?, action: Selector) {
        recordSliderView.sweetnessView.slider.addTarget(target, action: action, for: .valueChanged)
        recordSliderView.acidityView.slider.addTarget(target, action: action, for: .valueChanged)
        recordSliderView.tanninView.slider.addTarget(target, action: action, for: .valueChanged)
        recordSliderView.bodyView.slider.addTarget(target, action: action, for: .valueChanged)
        recordSliderView.alcoholView.slider.addTarget(target, action: action, for: .valueChanged)
    }
    
    func updateLabels() {
        chartHeaderView.setName(eng: "Palate", kor: "맛")
        recordSliderView.propertyHeader.setName(eng: "Graph Record", kor: "그래프 상세 기록")
    }
}