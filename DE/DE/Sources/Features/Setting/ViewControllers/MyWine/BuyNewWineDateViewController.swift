// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network
// 기기대응 완료
// 보유와인 날짜 선택

public class BuyNewWineDateViewController: UIViewController {
    
    let tastedDateView = MyWineDateView()
    var selectedDate: DateComponents?
    let navigationBarManager = NavigationBarManager()
    
    let wineData = TNWineDataManager.shared

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tastedDateView.setWineName(MyOwnedWineManager.shared.getWineName())
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
            MyOwnedWineManager.shared.setBuyDate(dateString)
            
            let nextVC = PriceNewWineViewController()
            nextVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(nextVC, animated: true)
        } else {
            print("선택된 날짜를 Date로 변환할 수 없습니다.")
        }
        
    }
}

extension BuyNewWineDateViewController: UICalendarSelectionSingleDateDelegate {
    public func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let validDateComponents = dateComponents else {
            return
        }
        selectedDate = validDateComponents
        
        tastedDateView.calender.reloadDecorations(forDateComponents: [validDateComponents], animated: true)
        self.tastedDateView.nextButton.isEnabled(isEnabled: true)
    }
}

extension BuyNewWineDateViewController: UICalendarViewDelegate {
    public func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        if dateComponents == selectedDate {
            return .customView {
                let backgroundView = UIView()
                backgroundView.backgroundColor = AppColor.purple100
                backgroundView.layer.cornerRadius = 18 // 원형으로 만들기 위해 cornerRadius를 반지름으로 설정
                backgroundView.layer.masksToBounds = true
                
                return backgroundView
            }
        }
        return nil
    }
}

