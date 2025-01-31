// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then

import CoreModule

// 4번 선택 뷰컨 테이스팅 노트 : 팔레트 선택

public class RecordGraphViewController: UIViewController {
    
    let navigationBarManager = NavigationBarManager()
    let tnManager = NewTastingNoteManager.shared
    
    private var sliderValues: [String: Int] = [:]
    
    let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    
    let contentView = UIView().then {
        $0.backgroundColor = AppColor.bgGray
    }
    
    let header = TopView(currentPage: 4, entirePage: 5)
    
    private let recordGraphView = RecordGraphView()
    
    let nextButton = CustomButton(
        title: "다음",
        titleColor: .white,
        isEnabled: true
    )
    
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
        contentView.addSubview(nextButton)
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
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(recordGraphView.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.bottom).offset(40)
        }
    }
    
    private func setupActions() {
        nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
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
        print("nextVC Tapped")
        saveSliderValues()
        let nextVC = RatingWineViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    private func saveSliderValues() {
        //테노 매니저에 설정 값 저장
        tnManager.savePalate(sugarContent: Int(recordGraphView.recordSliderView.sweetnessView.slider.value), acidity: Int(recordGraphView.recordSliderView.acidityView.slider.value), tannin: Int(recordGraphView.recordSliderView.tanninView.slider.value), body: Int(recordGraphView.recordSliderView.bodyView.slider.value), alcohol: Int(recordGraphView.recordSliderView.alcoholView.slider.value))
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
