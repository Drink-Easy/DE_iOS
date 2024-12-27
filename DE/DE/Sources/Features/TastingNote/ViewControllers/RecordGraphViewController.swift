//
//  RecordGraphViewController.swift
//  Drink-EG
//
//  Created by 이수현 on 11/18/24.
//

import UIKit

public class RecordGraphViewController: UIViewController {
    
    let recordGraphView = RecordGraphView()
    private var sliderValues: [String: Int] = [:]
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view = recordGraphView
        setupActions()
    }
    
    func setupActions() {
        recordGraphView.navView.backButton.addTarget(self, action: #selector(prevVC), for: .touchUpInside)
        recordGraphView.nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
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
    
}
