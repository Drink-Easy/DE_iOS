// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then

import CoreModule
import DesignSystem

// 4번 선택 뷰컨 테이스팅 노트 : 팔레트 선택

public class RecordGraphViewController: UIViewController, UIScrollViewDelegate, FirebaseTrackable {
    public var screenName: String = Tracking.VC.tnRecordGraphVC
    
    let navigationBarManager = NavigationBarManager()
    let wineData = TNWineDataManager.shared
    let tnManager = NewTastingNoteManager.shared
    
    private var sliderValues: [String: Int] = [:]
    
    let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    
    let contentView = UIView().then {
        $0.backgroundColor = AppColor.background
    }
    
    let header = TopView(currentPage: 4, entirePage: 5)
    private var smallTitleLabel = UILabel()
    
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
        header.setTitleLabel(title: wineData.wineName)
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
        setNavBarAppearance(navigationController: self.navigationController)
        saveSliderValues()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
    }
    
    private func setupUI() {
        view.backgroundColor = AppColor.background
        view.addSubview(scrollView)
        scrollView.delegate = self
        
        
        contentView.addSubview(header)
        contentView.addSubview(recordGraphView)
        contentView.addSubview(nextButton)
        scrollView.addSubview(contentView)
        
        header.setTitleLabel(title: wineData.wineName)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        header.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(DynamicPadding.dynamicValue(10.0))
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.greaterThanOrEqualTo(62)
        }
        
        recordGraphView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(Constants.superViewHeight * 0.5 + 510)
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
        
        smallTitleLabel = navigationBarManager.setNReturnTitle(
            to: navigationItem,
            title: wineData.wineName,
            textColor: AppColor.black
        )
        smallTitleLabel.isHidden = true
    }
    
    @objc private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func nextVC() {
        self.logButtonClick(screenName: self.screenName,
                            buttonName: Tracking.ButtonEvent.nextBtnTapped,
                       fileName: #file)
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
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let largeTitleBottom = header.frame.maxY + 5
        
        UIView.animate(withDuration: 0.1) {
            self.header.alpha = offsetY > largeTitleBottom ? 0 : 1
            self.smallTitleLabel.isHidden = !(offsetY > largeTitleBottom)
        }
    }
}
