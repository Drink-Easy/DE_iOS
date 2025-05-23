// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import DesignSystem
import Network
import SnapKit
import Then
// 기기대응 완료
// 보유와인 정보 수정

class ChangeMyOwnedWineViewController: UIViewController, FirebaseTrackable {
    var screenName: String = Tracking.VC.updateMyWineVC
    
    weak var delegate: ChildViewControllerDelegate?
    
    let navigationBarManager = NavigationBarManager()
    lazy var editInfoView = ChangeMyOwnedWineView()
    
    let networkService = MyWineService()
    private let errorHandler = NetworkErrorHandler()
    
    var registerWine: MyWineViewModel?
    
    lazy var selectedDate: DateComponents = {
        guard let wine = registerWine else { return Calendar.current.dateComponents([.year, .month, .day], from: Date()) }
        
        guard let date = wine.getBuyDate() else {
            return Calendar.current.dateComponents([.year, .month, .day], from: Date())
        }
        return date
    }()
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(indicator)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background
        setupUI()
        setupNavigationBar()
        setupActions()
        hideKeyboardWhenTappedAround()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
    }
    
    func setupActions() {
        configureCalendarSelection()
        editInfoView.priceTextField.textField.addTarget(self, action: #selector(checkEmpty), for: .allEditingEvents)
        editInfoView.nextButton.addTarget(self, action: #selector(completeEdit), for: .touchUpInside)
    }
    
    func setupUI() {
        guard let wine = registerWine else {return}
        
        editInfoView.setWinePrice(wine.purchasePrice)
        
        view.addSubview(editInfoView)
        editInfoView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(40))
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
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
            textColor: AppColor.black
        )
        
        navigationBarManager.addRightButton(
            to: navigationItem,
            icon: "trash",
            target: self,
            action: #selector(deleteNewWine),
            tintColor: AppColor.gray70
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
    
    @objc private func deleteNewWine() {

        guard let currentWine = self.registerWine else { return }
        
        let alert = UIAlertController(
            title: "이 와인을 삭제하시겠습니까?",
            message: "\(currentWine.wineName)",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.deleteBtnTapped, fileName: #file)
            self.view.showBlockingView()

            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc
    private func completeEdit() {
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.updatemyWineBtnTapped, fileName: #file)
        guard let wine = registerWine else { return }
        callUpdateAPI(wineId: wine.myWineId, price: checkPrice(), buyDate: checkDate())
        DispatchQueue.main.async {
            self.view.hideBlockingView()
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func checkEmpty() {
        guard let text = self.editInfoView.priceTextField.text else {
            editInfoView.nextButton.isEnabled(isEnabled: false)
            return
        }

        if text.isEmpty {
            editInfoView.nextButton.isEnabled(isEnabled: false)
        } else {
            editInfoView.nextButton.isEnabled(isEnabled: true)
        }

        if text.count >= 10 {
            showToastMessage(message: "와인 가격은 10억까지만 가능해요.", yPosition: view.frame.height * 0.5)
            editInfoView.nextButton.isEnabled(isEnabled: false)
        }
    }
    
    private func checkPrice() -> Int? {
        guard let price = self.editInfoView.priceTextField.text else { return nil}
        guard let priceInt = Int(price) else {return nil}
        
        return priceInt
    }
    
    private func checkDate() -> String? {
        guard let date = Calendar.current.date(from: selectedDate) else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한국 시간대 설정
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
    private func callDeleteAPI() {
        guard let wine = registerWine else {return}
        
        self.view.showBlockingView()
        Task {
            do {
                _ = try await networkService.deleteMyWine(myWineId: wine.myWineId)
            } catch {
                self.view.hideBlockingView()
                errorHandler.handleNetworkError(error, in: self)
            }
        }
    }
    
    private func callUpdateAPI(wineId: Int, price: Int?, buyDate: String?) {
        let data = networkService.makeUpdateDTO(buyDate: buyDate, buyPrice: price)
        self.view.showBlockingView()
        Task {
            do {
                _ = try await networkService.updateMyWine(myWineId: wineId, data: data)
//                delegate?.didUpdateData(true)
            } catch {
                self.view.hideBlockingView()
                errorHandler.handleNetworkError(error, in: self)
            }
        }
    }
}

extension ChangeMyOwnedWineViewController: UICalendarSelectionSingleDateDelegate {
    public func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let validDateComponents = dateComponents else { return }
        
        selectedDate = validDateComponents
        editInfoView.calender.reloadDecorations(forDateComponents: [validDateComponents], animated: true)
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
