// Copyright © 2025 DRINKIG. All rights reserved

import UIKit
import CoreModule
import DesignSystem
import SnapKit
import Then
// step 1. 빈티지 선택

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
            self?.vintageView.nextButton.isEnabled(isEnabled: true)
        }
        
        vintageView.yearPicker.onLabelTapped = { [weak self] in
            guard let self else { return }
            let modal = YearPickerModalViewController(
                minYear: vintageView.yearPicker.minYear,
                maxYear: vintageView.yearPicker.maxYear,
                selectedYear: vintageView.yearPicker.selectedYear
            )

            modal.onYearConfirmed = { [weak self] selected in
                self?.vintageView.yearPicker.setSelectedYear(selected)
                self?.vintageView.nextButton.isEnabled = true
                self?.vintageView.yearPicker.updatePickerView(isModalOpen: false)
            }
            
            modal.modalPresentationStyle = .pageSheet

            if let sheet = modal.sheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersGrabberVisible = true
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            }
            modal.presentationController?.delegate = self
            
            vintageView.yearPicker.updatePickerView(isModalOpen: true)
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
        wineManager.resetVintage()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
//        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.nextBtnTapped, fileName: #file)
        guard let selectedYear = vintageView.yearPicker.selectedYear else {
            // 연도가 선택되지 않았을 경우: Alert 표시 등
            showToastMessage(message: "연도가 선택되지 않았습니다.", yPosition: view.frame.height * 0.5)
            return
        }
        
        // wineManager에 선택한 연도 저장
        wineManager.setVintage(selectedYear)
        
        // 다음 화면으로 이동
        let vc = BuyNewWineDateViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension SelectVintageViewController: UIAdaptivePresentationControllerDelegate {
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        vintageView.yearPicker.updatePickerView(isModalOpen: false)
    }
}
