// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import DesignSystem
import Network

// 와인 시음 날짜 선택 1번

public class TastedDateViewController: UIViewController, FirebaseTrackable {
    public var screenName: String = Tracking.VC.tnTastedDateVC
    lazy var tastedDateView = TastedDateView()
    let tnManger = NewTastingNoteManager.shared
    let wineData = TNWineDataManager.shared
    var selectedDate: DateComponents?
    let navigationBarManager = NavigationBarManager()
    
    let despText = "시음 시기를 선택해 주세요"

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tastedDateView.topView.setTitleLabel(title: self.wineData.wineName,
                                             titleStyle: AppTextStyle.KR.subtitle1,
                                             titleColor: AppColor.purple100,
                                             description: despText,
                                             descriptionStyle: AppTextStyle.KR.head,
                                             descriptionColor: AppColor.black)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupNavigationBar()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
    }
    
    func setupUI() {
        view.backgroundColor = AppColor.background
        
        view.addSubview(tastedDateView)
        tastedDateView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(10.0))
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
            make.bottom.equalToSuperview()
        }
    }
    
    func setupActions() {
        tastedDateView.nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        
        tastedDateView.calender.selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
        tastedDateView.calender.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC)
        )
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // ✅ UICalendarView가 리로드될 때 불필요한 크기 변경을 방지
//        tastedDateView.calendarContainer.layoutIfNeeded()
        tastedDateView.calender.invalidateIntrinsicContentSize()
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
        self.logButtonClick(screenName: self.screenName,
                            buttonName: Tracking.ButtonEvent.nextBtnTapped,
                       fileName: #file)
        guard let selectedDate = selectedDate else {
            return
        }

        if let date = Calendar.current.date(from: selectedDate) {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko_KR") // 한국 시간대 설정
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date)
            
            tnManger.saveTasteDate(dateString)
            
            let nextVC = ChooseWineColorViewController()
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
}

extension TastedDateViewController: UICalendarSelectionSingleDateDelegate {
    public func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let validDateComponents = dateComponents else {
            return
        }
        selectedDate = validDateComponents
        tastedDateView.calender.reloadDecorations(forDateComponents: [validDateComponents], animated: true)
        
        UIView.animate(withDuration: 0.2) {
            self.tastedDateView.calendarContainer.layoutIfNeeded()
        }
        
        self.tastedDateView.nextButton.isEnabled(isEnabled: true)
    }
    
    /// ✅ 미래 날짜 선택 차단 (미래 날짜 선택을 아예 못하게 막음)
    public func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
        guard let dateComponents = dateComponents,
              let selectedDate = Calendar.current.date(from: dateComponents) else { return false }
        
        let today = Calendar.current.startOfDay(for: Date()) // 오늘 날짜 (00:00:00 기준)
        
        // ✅ 미래 날짜 선택 차단 (미래 날짜면 false 반환)
        return selectedDate <= today
    }
    
    
}

extension TastedDateViewController: UICalendarViewDelegate {
    public func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        if dateComponents == selectedDate {
            return .customView {
                let backgroundView = UIView()
                backgroundView.backgroundColor = AppColor.purple100
                backgroundView.layer.cornerRadius = 16 // 원형으로 만들기 위해 cornerRadius를 반지름으로 설정
                backgroundView.layer.masksToBounds = true
                
                return backgroundView
            }
        }
        return nil
    }
}
