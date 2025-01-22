// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network
import SnapKit
import Then

// 보유와인 정보 수정

class ChangeMyOwnedWineViewController: UIViewController {
    let navigationBarManager = NavigationBarManager()
    lazy var editInfoView = ChangeMyOwnedWineView()
    
    var registerWine: MyOwnedWine = MyOwnedWine()
    lazy var selectedDate: DateComponents = {
        guard let date = registerWine.getBuyDate() else {
            return Calendar.current.dateComponents([.year, .month, .day], from: Date())
        }
        return date
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupNavigationBar()
        setupActions()
    }
    
    func setupActions() {
        configureCalendarSelection()
        editInfoView.nextButton.addTarget(self, action: #selector(completeEdit), for: .touchUpInside)
    }
    
    func setupUI() {
        editInfoView.setWinePrice(registerWine.price)
        
        view.addSubview(editInfoView)
        editInfoView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
        }
    }
    
    func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(backButtonTapped)
        )
        
        navigationBarManager.setTitle(
            to: navigationItem,
            title: "정보 수정하기",
            textColor: AppColor.black ?? .black
        )
        
        navigationBarManager.addRightButton(
            to: navigationItem,
            icon: "trash",
            target: self,
            action: #selector(deleteNewWine),
            tintColor: AppColor.gray70 ?? .gray
        )
    }
    
    private func configureCalendarSelection() {
        let singleDateSelection = UICalendarSelectionSingleDate(delegate: self)
        singleDateSelection.selectedDate = self.selectedDate
        editInfoView.calender.selectionBehavior = singleDateSelection
        editInfoView.calender.delegate = self
    }
    
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func deleteNewWine() {
        // 삭제 api 호출
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func completeEdit() {
        // patch api 호출
        navigationController?.popViewController(animated: true)
    }
    
}

extension ChangeMyOwnedWineViewController: UICalendarSelectionSingleDateDelegate {
    public func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let validDateComponents = dateComponents else { return }
        
        selectedDate = validDateComponents
        editInfoView.calender.reloadDecorations(forDateComponents: [validDateComponents], animated: true)
    }
}

extension ChangeMyOwnedWineViewController: UICalendarViewDelegate {
    public func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        if dateComponents == selectedDate {
            return .customView {
                let backgroundView = UIView()
                backgroundView.backgroundColor = AppColor.purple100
                backgroundView.layer.cornerRadius = 18 // 동적 설정 필요할 수도 TODO
                backgroundView.layer.masksToBounds = true
                
                return backgroundView
            }
        }
        return nil
    }
}
