// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then

import CoreModule
import DesignSystem
import Network

//// 테이스팅 노트 palate 수정
public class ChangePalateVC: UIViewController, UIScrollViewDelegate, FirebaseTrackable {
    public var screenName: String = Tracking.VC.editPalateVC
    
    let navigationBarManager = NavigationBarManager()
    let networkService = TastingNoteService()
    private let errorHandler = NetworkErrorHandler()
    let tnManager = NewTastingNoteManager.shared
    let wineData = TNWineDataManager.shared
    
    public var palateInfo: [Double] = []
    private var sliderValues: [String: Int] = [:]
    
    let scrollView = UIScrollView().then {
        $0.isScrollEnabled = true
    }
    
    let contentView = UIView().then {
        $0.backgroundColor = AppColor.background
    }
    public lazy var wineNameTitle = UILabel().then {
        $0.numberOfLines = 0
    }
    private let recordGraphView = RecordGraphView()
    let nextButton = CustomButton(
        title: "저장하기",
        titleColor: .white,
        isEnabled: true
    )
    private var smallTitleLabel = UILabel()

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(indicator)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.setWineName(wineData.wineName)
        
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
        palateInfo = tnManager.getSliderValues()
        setupUI()
        setupActions()
        setupNavigationBar()
        initializeSliderValues()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
    }
    
    public func setWineName(_ name: String) {
        AppTextStyle.KR.head.apply(to: self.wineNameTitle, text: name, color: AppColor.black)
    }
    
    private func setupUI() {
        view.backgroundColor = AppColor.background
        view.addSubview(scrollView)
        
        contentView.addSubview(wineNameTitle)
        contentView.addSubview(recordGraphView)
        contentView.addSubview(nextButton)
        scrollView.addSubview(contentView)
        
        scrollView.delegate = self
        self.setWineName(wineData.wineName)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.bottom).offset(40)
        }
        
        wineNameTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(DynamicPadding.dynamicValue(10.0))
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.greaterThanOrEqualTo(62)
        }
        
        recordGraphView.snp.makeConstraints { make in
            make.top.equalTo(wineNameTitle.snp.bottom).offset(36)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(Constants.superViewHeight * 0.5 + 510)
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
    
    @objc private func saveButtonTapped() {
        logButtonClick(screenName: self.screenName,
                            buttonName: Tracking.ButtonEvent.saveBtnTapped,
                       fileName: #file)
        callUpdateAPI()

    }
    
    private func callUpdateAPI() {
        let updateData = networkService.makeUpdateNoteBodyDTO(sugarContent: Int(recordGraphView.recordSliderView.sweetnessView.slider.value), acidity: Int(recordGraphView.recordSliderView.acidityView.slider.value), tannin: Int(recordGraphView.recordSliderView.tanninView.slider.value), body: Int(recordGraphView.recordSliderView.bodyView.slider.value), alcohol: Int(recordGraphView.recordSliderView.alcoholView.slider.value))
        
        let tnData = networkService.makeUpdateNoteDTO(noteId: tnManager.noteId, body: updateData)
        Task {
            do {
                self.view.showBlockingView()
                let _ = try await networkService.patchNote(data: tnData)
                self.view.hideBlockingView()
                navigationController?.popViewController(animated: true)
            } catch {
                self.view.hideBlockingView()
                errorHandler.handleNetworkError(error, in: self)
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
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let largeTitleBottom = wineNameTitle.frame.maxY + 5
        
        UIView.animate(withDuration: 0.1) {
            self.wineNameTitle.alpha = offsetY > largeTitleBottom ? 0 : 1
            self.smallTitleLabel.isHidden = !(offsetY > largeTitleBottom)
        }
    }
}
