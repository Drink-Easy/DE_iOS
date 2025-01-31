// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network

// 와인 시음 날짜 선택 1번

public class TastedDateViewController: UIViewController {
    lazy var tastedDateView = TastedDateView()
    let tnManger = NewTastingNoteManager.shared
    let wineData = TNWineDataManager.shared
    var selectedDate: DateComponents?
    let navigationBarManager = NavigationBarManager()

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tastedDateView.topView.title.text = self.wineData.wineName
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupNavigationBar()
    }
    
    func setupUI() {
        view.backgroundColor = AppColor.bgGray
        
        view.addSubview(tastedDateView)
        tastedDateView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(10))
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
    
//    public override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tastedDateView.calender.layoutIfNeeded()
//    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
        guard let selectedDate = selectedDate else {
            print("선택된 날짜가 없습니다.")
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
        } else {
            print("선택된 날짜를 Date로 변환할 수 없습니다.")
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
        self.tastedDateView.nextButton.isEnabled(isEnabled: true)
    }
    
    
}

extension TastedDateViewController: UICalendarViewDelegate {
    public func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        if dateComponents == selectedDate {
            return .customView {
                let backgroundView = UIView()
                backgroundView.backgroundColor = AppColor.purple100
                backgroundView.layer.cornerRadius = 15 // ✅ 너무 크면 선택 시 레이아웃 변할 가능성 있음
                backgroundView.layer.masksToBounds = true

                // ✅ SnapKit으로 크기 고정
                backgroundView.snp.makeConstraints { make in
                    make.width.height.equalTo(30) // ✅ 선택된 날짜의 배경 크기 고정
                }

                return backgroundView
            }
        }
        return nil
    }
}

//extension TastedDateViewController: UICalendarViewDelegate {
//    public func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
//        if dateComponents == selectedDate {
//            return .customView {
//                let backgroundView = UIView()
//                backgroundView.backgroundColor = AppColor.purple100
//                backgroundView.layer.cornerRadius = 18
//                backgroundView.layer.masksToBounds = true
//                
//                return backgroundView
//            }
//        }
//        return nil
//    }
//}

