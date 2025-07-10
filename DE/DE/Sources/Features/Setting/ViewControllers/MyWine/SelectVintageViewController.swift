// Copyright © 2025 DRINKIG. All rights reserved

import UIKit
import CoreModule
import DesignSystem
import SnapKit
import Then

final class SelectVintageViewController: UIViewController {

    let navigationBarManager = NavigationBarManager()
    let vintageView = MyWineVintageView()
    
    let wineManager = MyOwnedWineManager.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vintageView.setWineName(wineManager.getWineName())
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupNavigationBar()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        logScreenView(fileName: #file)
    }

    func setupUI() {
        view.backgroundColor = AppColor.background
        
        view.addSubview(vintageView)
        vintageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(5.0))
            $0.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
            $0.bottom.equalToSuperview()
        }
    }
    
    func setupActions() {
        vintageView.nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        
        vintageView.yearPicker.onYearSelected = { [weak self] year in
            print("선택된 연도: \(year)")
            self?.vintageView.nextButton.isEnabled(isEnabled: true)
        }
        
        
        vintageView.yearPicker.onLabelTapped = { [weak self] in
            guard let self else { return }
            let modal = YearPickerModalViewController(
                minYear: vintageView.yearPicker.minYear,
                maxYear: vintageView.yearPicker.maxYear,
            )

            modal.onYearConfirmed = { [weak self] selected in
                self?.vintageView.yearPicker.setSelectedYear(selected) // 아래 확장으로 지원
                self?.vintageView.nextButton.isEnabled = true
            }
            
            modal.modalPresentationStyle = .pageSheet

            if let sheet = modal.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            }

            self.present(modal, animated: true)
        }
        
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
//        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.nextBtnTapped, fileName: #file)
        guard let selectedYear = vintageView.yearPicker.selectedYear else {
            // 연도가 선택되지 않았을 경우: Alert 표시 등
            showToastMessage(message: "연도가 선택되지 않았습니다.", yPosition: view.frame.height * 0.5)
            return
        }
        
        // 선택한 연도 검증
        print("다음 화면으로 넘어갑니다. 현재 선택된 연도 \(selectedYear)")
        
        // wineManager에 선택한 연도 저장
        
        // 다음 화면으로 이동
    }
}
