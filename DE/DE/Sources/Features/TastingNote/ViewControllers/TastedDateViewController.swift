// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

public class TastedDateViewController: UIViewController {

    let tastedDateView = TastedDateView()
    var selectedDate: DateComponents?
    let navigationBarManager = NavigationBarManager()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupNavigationBar()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tastedDateView)
        tastedDateView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
            action: #selector(prevVC),
            tintColor: AppColor.gray80!
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
            // 날짜를 `String`으로 변환
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date)
            
            // UserDefaults에 저장
            UserDefaults.standard.set(dateString, forKey: "tasteDate")
            print("날짜 저장됨: \(dateString)")
        }
        
        let nextVC = ChooseWineColorViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
}

extension TastedDateViewController: UICalendarSelectionSingleDateDelegate {
    public func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let validDateComponents = dateComponents else {
            return
        }
        // 선택된 날짜를 저장
        selectedDate = validDateComponents
        
        // 선택된 날짜에 대한 장식 업데이트
        tastedDateView.calender.reloadDecorations(forDateComponents: [validDateComponents], animated: true)
    }
}

extension TastedDateViewController: UICalendarViewDelegate {
    public func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        // Check if the current date matches the selected date
        if dateComponents == selectedDate {
            return .customView {
                let backgroundView = UIView()
                backgroundView.backgroundColor = UIColor(hex: "#B06FCD")
                backgroundView.layer.cornerRadius = 10
                return backgroundView
            }
        }
        return nil
    }
}

