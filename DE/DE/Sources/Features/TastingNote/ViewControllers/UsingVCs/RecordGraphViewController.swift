// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then

import CoreModule

//// 테이스팅 노트 만들기 4/5
public class RecordGraphViewController: UIViewController {
    
    let navigationBarManager = NavigationBarManager()
    let tnManager = NewTastingNoteManager.shared
    
    let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    
    let contentView = UIView().then {
        $0.backgroundColor = AppColor.bgGray
    }
    
    let header = TopView(currentPage: 4, entirePage: 5)
    
    private let recordGraphView = RecordGraphView()
    
    private var sliderValues: [String: Int] = [:]
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        recordGraphView.updateLabels()
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
    
    private func setupUI() {
        view.backgroundColor = AppColor.bgGray
        view.addSubview(scrollView)
        
        
        contentView.addSubview(header)
        contentView.addSubview(recordGraphView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        
        recordGraphView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(Constants.superViewHeight)
        }
        
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(recordGraphView.snp.bottom).offset(100)
        }
    }
    
    private func setupActions() {
        recordGraphView.nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        recordGraphView.setupSliders(target: self, action: #selector(sliderValueChanged))
    }
    
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC)
        )
    }
    
    @objc private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func nextVC() {
        saveSliderValues()
        let nextVC = RatingWineViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func saveSliderValues() {
        //테노 매니저에 설정 값 저장
        tnManager.saveSugarContent(Int(recordGraphView.recordSliderView.sweetnessView.slider.value))
        tnManager.saveAcidity(Int(recordGraphView.recordSliderView.acidityView.slider.value))
        tnManager.saveTannin(Int(recordGraphView.recordSliderView.tanninView.slider.value))
        tnManager.saveBody(Int(recordGraphView.recordSliderView.bodyView.slider.value))
        tnManager.saveAlcohol(Int(recordGraphView.recordSliderView.alcoholView.slider.value))
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        switch sender {
        case recordGraphView.recordSliderView.sweetnessView.slider:
            sliderValues["Sweetness"] = Int(sender.value)
        case recordGraphView.recordSliderView.acidityView.slider:
            sliderValues["Acidity"] = Int(sender.value)
        case recordGraphView.recordSliderView.tanninView.slider:
            sliderValues["Tannin"] = Int(sender.value)
        case recordGraphView.recordSliderView.bodyView.slider:
            sliderValues["Body"] = Int(sender.value)
        case recordGraphView.recordSliderView.alcoholView.slider:
            sliderValues["Alcohol"] = Int(sender.value)
        default:
            break
        }
        recordGraphView.chartView.viewModel.loadSliderValues(from: sliderValues)
    }
}
