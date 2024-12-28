//
//  RecordGraphViewController.swift
//  Drink-EG
//
//  Created by 이수현 on 11/18/24.
//

import UIKit
import CoreModule

public class RecordGraphViewController: UIViewController {
    
    let recordGraphView = RecordGraphView()
    private var sliderValues: [String: Int] = [:] {
        didSet {
            updatePolygonChart()
        }
    }
    let navigationBarManager = NavigationBarManager()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view = recordGraphView
        setupActions()
        setupNavigationBar()
        saveSliderValues()
        updatePolygonChart()
    }
    
    func setupActions() {
        recordGraphView.nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        
        recordGraphView.sweetSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        recordGraphView.acidSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        recordGraphView.tanninSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        recordGraphView.bodySlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        recordGraphView.alcoholSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
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
        recordGraphView.polygonChart.dataList = chartData
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
        sliderValues["Sweetness"] = Int(recordGraphView.sweetSlider.value)
        sliderValues["Acidity"] = Int(recordGraphView.acidSlider.value)
        sliderValues["Tannin"] = Int(recordGraphView.tanninSlider.value)
        sliderValues["Body"] = Int(recordGraphView.bodySlider.value)
        sliderValues["Alcohol"] = Int(recordGraphView.alcoholSlider.value)
        
        // UserDefaults에 저장
        UserDefaults.standard.set(sliderValues, forKey: "SliderValues")
        print("저장된 슬라이더 값: \(sliderValues)")
        
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        switch sender {
        case recordGraphView.sweetSlider:
            sliderValues["Sweetness"] = Int(sender.value)
        case recordGraphView.acidSlider:
            sliderValues["Acidity"] = Int(sender.value)
        case recordGraphView.tanninSlider:
            sliderValues["Tannin"] = Int(sender.value)
        case recordGraphView.bodySlider:
            sliderValues["Body"] = Int(sender.value)
        case recordGraphView.alcoholSlider:
            sliderValues["Alcohol"] = Int(sender.value)
        default:
            break
        }
    }
    
}
