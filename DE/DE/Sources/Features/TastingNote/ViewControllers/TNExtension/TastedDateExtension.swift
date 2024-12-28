// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

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

