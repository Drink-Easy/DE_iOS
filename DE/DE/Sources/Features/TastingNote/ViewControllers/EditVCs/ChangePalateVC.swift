// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then

import CoreModule
import Network

//// 테이스팅 노트 palate 수정
public class ChangePalateVC: UIViewController {
    
    let navigationBarManager = NavigationBarManager()
    let networkService = TastingNoteService()
    
    let tnManager = NewTastingNoteManager.shared
    let wineData = TNWineDataManager.shared
    
    public var palateInfo: [Double] = []
    private var sliderValues: [String: Int] = [:]
    
    let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    
    let contentView = UIView().then {
        $0.backgroundColor = AppColor.bgGray
    }
    private let wineNameTitle = WineNameView()
    private let recordGraphView = RecordGraphView()
    let nextButton = CustomButton(
        title: "저장하기",
        titleColor: .white,
        isEnabled: true
    )

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        wineNameTitle.setTitleLabel(wineData.wineName)
        
        recordGraphView.recordSliderView.sweetnessView.slider.setSavedValue(palateInfo[0])
        recordGraphView.recordSliderView.alcoholView.slider.setSavedValue(palateInfo[1])
        recordGraphView.recordSliderView.tanninView.slider.setSavedValue(palateInfo[2])
        recordGraphView.recordSliderView.bodyView.slider.setSavedValue(palateInfo[3])
        recordGraphView.recordSliderView.acidityView.slider.setSavedValue(palateInfo[4])
        recordGraphView.updateLabels()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(indicator)
        palateInfo = tnManager.getSliderValues()
        setupUI()
        setupActions()
        setupNavigationBar()
        initializeSliderValues()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColor.bgGray
        view.addSubview(scrollView)
        
        contentView.addSubview(wineNameTitle)
        contentView.addSubview(recordGraphView)
        contentView.addSubview(nextButton)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.bottom).offset(40)
        }
        
        wineNameTitle.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.greaterThanOrEqualTo(62)
        }
        
        recordGraphView.snp.makeConstraints { make in
            make.top.equalTo(wineNameTitle.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(Constants.superViewHeight * 0.5 + 460)
        }
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(recordGraphView.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview().inset(24)
        }
    }
    
    private func setupActions() {
        nextButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
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
        callUpdateAPI()
        
        // popViewController
        // 데이터 매니저에 변경된 데이터 저장하기
    }
    
    private func callUpdateAPI() {
        let updateData = networkService.makeUpdateNoteBodyDTO(sugarContent: Int(recordGraphView.recordSliderView.sweetnessView.slider.value), acidity: Int(recordGraphView.recordSliderView.acidityView.slider.value), tannin: Int(recordGraphView.recordSliderView.tanninView.slider.value), body: Int(recordGraphView.recordSliderView.bodyView.slider.value), alcohol: Int(recordGraphView.recordSliderView.alcoholView.slider.value))
        
        let tnData = networkService.makeUpdateNoteDTO(noteId: tnManager.noteId, body: updateData)
        Task {
            do {
                self.view.showBlockingView()
                try await networkService.patchNote(data: tnData)
                self.view.hideBlockingView()
                navigationController?.popViewController(animated: true)
            }
        }
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
    
    private func initializeSliderValues() {
        sliderValues["Sweetness"] = Int(palateInfo[0])
        sliderValues["Alcohol"] = Int(palateInfo[1])
        sliderValues["Tannin"] = Int(palateInfo[2])
        sliderValues["Body"] = Int(palateInfo[3])
        sliderValues["Acidity"] = Int(palateInfo[4])
        
        recordGraphView.chartView.viewModel.loadSliderValues(from: sliderValues)
    }
}
