// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SwiftUI

import SnapKit
import Then

import CoreModule
import Network

public class RecordGraphViewController: UIViewController {
    
    let navigationBarManager = NavigationBarManager()
    let tnManager = NewTastingNoteManager.shared
    let wineData = TNWineDataManager.shared
    
    private var sliderValues: [String: Int] = [:]
    
    //MARK: UI Elements
    let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    
    let contentView = UIView().then {
        $0.backgroundColor = AppColor.bgGray
    }
    
    private lazy var header = TopView(currentPage: 4, entirePage: 5)
    let chartView = PolygonChartView()
    let recordGraphView = RecordGraphView()
    
    private let nextButton = CustomButton(
        title: "다음",
        titleColor: .white,
        isEnabled: true
    ).then {
        $0.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
    }
    
    let wineName = UserDefaults.standard.string(forKey: "wineName")
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        chartView.propertyHeader.setName(eng: "Palate", kor: "맛")
        recordGraphView.propertyHeader.setName(eng: "Graph Record", kor: "그래프 상세 기록")
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupNavigationBar()
        saveSliderValues()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = AppColor.bgGray
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [header, chartView, recordGraphView, nextButton].forEach{
            contentView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // 화면 전체에 맞춤
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        header.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(24)
            make.height.greaterThanOrEqualTo(62)
        }
        chartView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(24)
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(Constants.superViewHeight * 0.5)
        }
        recordGraphView.snp.makeConstraints { make in
            make.top.equalTo(chartView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(24)
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(Constants.superViewHeight * 0.5)
        }
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(recordGraphView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(28.0))
        }
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.bottom).offset(40)
        }
    }
    
    func setupActions() {
        nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        recordGraphView.sweetnessView.slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        recordGraphView.acidityView.slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        recordGraphView.tanninView.slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        recordGraphView.bodyView.slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        recordGraphView.alcoholView.slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
    }
    
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC)
        )
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
        saveSliderValues()
        let nextVC = RatingWineViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func saveSliderValues() {
        // UserDefaults에 저장
        tnManager.saveSugarContent(Int(recordGraphView.sweetnessView.slider.value))
        tnManager.saveAcidity(Int(recordGraphView.acidityView.slider.value))
        tnManager.saveTannin(Int(recordGraphView.tanninView.slider.value))
        tnManager.saveBody(Int(recordGraphView.bodyView.slider.value))
        tnManager.saveAlcohol(Int(recordGraphView.alcoholView.slider.value))
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        switch sender {
        case recordGraphView.sweetnessView.slider:
            sliderValues["Sweetness"] = Int(sender.value)
        case recordGraphView.acidityView.slider:
            sliderValues["Acidity"] = Int(sender.value)
        case recordGraphView.tanninView.slider:
            sliderValues["Tannin"] = Int(sender.value)
        case recordGraphView.bodyView.slider:
            sliderValues["Body"] = Int(sender.value)
        case recordGraphView.alcoholView.slider:
            sliderValues["Alcohol"] = Int(sender.value)
        default:
            break
        }
        chartView.viewModel.loadSliderValues(from: sliderValues)
    }
    
}
