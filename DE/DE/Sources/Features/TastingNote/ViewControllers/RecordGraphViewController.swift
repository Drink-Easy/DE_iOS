// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SwiftUI

import SnapKit
import Then

import CoreModule
import Network

public class PalateViewModel: ObservableObject {
    @Published var stats: [RadarData] = [RadarData(label: "당도", value: 0.2), RadarData(label: "알코올", value: 1.0), RadarData(label: "타닌", value: 0.2), RadarData(label: "바디", value: 0.6), RadarData(label: "산도" , value: 0.8)]
    
    func loadSliderValues() {
            if let savedValues = UserDefaults.standard.dictionary(forKey: "sliderValues") as? [String: Int] {
                stats = [
                    RadarData(label: "당도", value: Double(savedValues["Sweetness"] ?? 0) / 100),
                    RadarData(label: "알코올", value: Double(savedValues["Alcohol"] ?? 0) / 100),
                    RadarData(label: "타닌", value: Double(savedValues["Tannin"] ?? 0) / 100),
                    RadarData(label: "바디", value: Double(savedValues["Body"] ?? 0) / 100),
                    RadarData(label: "산도", value: Double(savedValues["Acidity"] ?? 0) / 100)
                ]
                print("로드된 슬라이더 값: \(savedValues)")
            } else {
                print("저장된 슬라이더 값 없음")
            }
        }
}

public class RecordGraphViewController: UIViewController {
    
    let navigationBarManager = NavigationBarManager()
    
    //MARK: UI Elements
    let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    
    let contentView = UIView().then {
        $0.backgroundColor = AppColor.bgGray
    }
    
    var viewModel = PalateViewModel()

    lazy var palateChart = PalateChartView(viewModel: viewModel)

    lazy var hostingController: UIHostingController<PalateChartView> = {
        let hostingController = UIHostingController(rootView: palateChart)
        hostingController.view.backgroundColor = AppColor.bgGray
        return hostingController
    }()
    
    private var sliderValues: [String: Int] = [:] {
        didSet {
            updatePolygonChart()
        }
    }
    
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
        //        DispatchQueue.main.async {
        //            self.recordGraphView.updateUI(wineName: self.wineName ?? "")
        //        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        //        self.view = recordGraphView
        setupUI()
        setupActions()
        setupNavigationBar()
        saveSliderValues()
        updatePolygonChart()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = AppColor.bgGray
        addChild(hostingController)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(hostingController.view)
        contentView.addSubview(recordGraphView)
        contentView.addSubview(nextButton)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // 화면 전체에 맞춤
        }
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        hostingController.view.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.superViewHeight * 0.1)
            make.centerX.equalToSuperview()
        }
        recordGraphView.snp.makeConstraints { make in
            make.top.equalTo(hostingController.view.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            
            make.width.equalToSuperview()
            make.height.equalTo(Constants.superViewHeight * 0.5)
        }
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(recordGraphView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(28.0))
            make.bottom.equalToSuperview().offset(-DynamicPadding.dynamicValue(40.0))
        }
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.bottom).offset(16)
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
            action: #selector(prevVC),
            tintColor: AppColor.gray80!
        )
    }
    
    private func updatePolygonChart() {
        let chartData = [
            RadarChartData(type: .sweetness, value: sliderValues["Sweetness"] ?? 0),
            RadarChartData(type: .acid, value: sliderValues["Acidity"] ?? 0),
            RadarChartData(type: .tannin, value: sliderValues["Tannin"] ?? 0),
            RadarChartData(type: .bodied, value: sliderValues["Body"] ?? 0),
            RadarChartData(type: .alcohol, value: sliderValues["Alcohol"] ?? 0)
        ]
        
        // 다각형 차트에 데이터 설정
        //        recordGraphView.polygonChart.dataList = chartData
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
        saveSliderValues()
        
        let nextVC = RatingWineViewController()
        nextVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func saveSliderValues() {
        // RecordGraphView의 슬라이더 값을 가져옴
        sliderValues["Sweetness"] = Int(recordGraphView.sweetnessView.slider.value)
        sliderValues["Acidity"] = Int(recordGraphView.acidityView.slider.value)
        sliderValues["Tannin"] = Int(recordGraphView.tanninView.slider.value)
        sliderValues["Body"] = Int(recordGraphView.bodyView.slider.value)
        sliderValues["Alcohol"] = Int(recordGraphView.alcoholView.slider.value)
        
        // UserDefaults에 저장
        UserDefaults.standard.set(sliderValues, forKey: "sliderValues")
        print("저장된 슬라이더 값: \(sliderValues)")
        
        viewModel.loadSliderValues()
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
        viewModel.loadSliderValues()
    }
    
}
