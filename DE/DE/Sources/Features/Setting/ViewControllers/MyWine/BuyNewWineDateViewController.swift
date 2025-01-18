// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network

// 구매 시기 선택 뷰 컨트롤러
// TODO : 도연

public class BuyNewWineDateViewController: UIViewController {

    let tastedDateView = BuyNewWineDateView()
    var selectedDate: DateComponents?
    let navigationBarManager = NavigationBarManager()
    
    let wineName = UserDefaults.standard.string(forKey: "wineName")

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tastedDateView.updateUI(wineName: self.wineName ?? "")
        }
    }
    
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
            self.selectedDate = DateComponents() // 오늘 날짜 배정?
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = Calendar.current.date(from: selectedDate) else {return}
        
        let dateString = dateFormatter.string(from: date)
        let nextVC = PriceNewWineViewController()
        nextVC.selectDate = dateString
        navigationController?.pushViewController(nextVC, animated: true)
    }
}

extension BuyNewWineDateViewController: UICalendarSelectionSingleDateDelegate {
    public func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let validDateComponents = dateComponents else {
            return
        }
        selectedDate = validDateComponents
        
        tastedDateView.calender.reloadDecorations(forDateComponents: [validDateComponents], animated: true)
    }
}

extension BuyNewWineDateViewController: UICalendarViewDelegate {
    public func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        // Check if the current date matches the selected date
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

