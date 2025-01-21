// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then

import CoreModule

//// 테이스팅 노트 palate 수정
public class ChangePalateVC: UIViewController {
    
    let navigationBarManager = NavigationBarManager()
    let tnManager = NewTastingNoteManager.shared
    
    let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    
    let contentView = UIView().then {
        $0.backgroundColor = AppColor.bgGray
    }
    private let wineNameTitle = WineNameView()
    private let recordGraphView = RecordGraphView()
    
    private var sliderValues: [String: Int] = [:]
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        wineNameTitle.setTitleLabel("와인이에용") //TODO: 와인이름 세팅
        recordGraphView.chartView.viewModel.loadSliderValues(from: sliderValues) //TODO: 원래 palate int 값 설정
        recordGraphView.updateLabels()
        recordGraphView.nextButton.setTitle("저장하기", for: .normal)
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
    }
    
    private func setupUI() {
        view.backgroundColor = AppColor.bgGray
        view.addSubview(scrollView)
        
        contentView.addSubview(wineNameTitle)
        contentView.addSubview(recordGraphView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        wineNameTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.greaterThanOrEqualTo(62)
        }
        
        recordGraphView.snp.makeConstraints { make in
            make.top.equalTo(wineNameTitle.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(Constants.superViewHeight)
        }
        
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(recordGraphView.snp.bottom).offset(100)
        }
    }
    
    private func setupActions() {
        recordGraphView.nextButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
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
    
    @objc private func saveButtonTapped() {
        //TODO: 수정 데이터 연결 api
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
