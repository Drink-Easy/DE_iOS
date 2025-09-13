// Copyright © 2025 DRINKIG. All rights reserved

import UIKit
import CoreModule
import DesignSystem
import SnapKit
import Then

final class ReusableVintageSelectionViewController: UIViewController {
    let navigationBarManager = NavigationBarManager()
    let vintageView = MyWineVintageView()
    
    private let viewModel: VintageSelectionViewModel
    
    public var onComplete: ((Int) -> Void)?
    
    init(viewModel: VintageSelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.vintageView.setTopSection(name: viewModel.screenTitle, descText: viewModel.screenDescription)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        logScreenView(fileName: #file)
    }
    
    private func setupUI() {
        view.backgroundColor = AppColor.background
        
        view.addSubview(vintageView)
        vintageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(5.0))
            $0.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
            $0.bottom.equalToSuperview()
        }
    }
    
    private func setupActions() {
        vintageView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
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
                sheet.delegate = self
            }
            
            vintageView.yearPicker.updatePickerView(isModalOpen: true)
            self.present(modal, animated: true)
        }
        
    }
    
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    @objc func backButtonTapped() {
        viewModel.handleBackButton()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextButtonTapped() {
        //        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.nextBtnTapped, fileName: #file)
        
        guard let selectedYear = vintageView.yearPicker.selectedYear else {
            showToastMessage(message: "연도가 선택되지 않았습니다.", yPosition: view.frame.height * 0.5)
            return
        }
        
        // 5. ViewModel에 선택된 빈티지 저장
        viewModel.save(vintage: selectedYear)
        
        // 6. 외부에서 주입받은 onComplete 클로저 실행
        onComplete?(selectedYear)
    }
    
    
}

extension ReusableVintageSelectionViewController: UIAdaptivePresentationControllerDelegate, UISheetPresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        vintageView.yearPicker.updatePickerView(isModalOpen: false)
    }
}
