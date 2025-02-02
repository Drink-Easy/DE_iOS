// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network
import SnapKit
import Then
// 기기대응 완료
// 보유와인 정보 수정

class ChangeMyOwnedWineViewController: UIViewController {
    let navigationBarManager = NavigationBarManager()
    lazy var editInfoView = ChangeMyOwnedWineView()
    
    let networkService = MyWineService()
    
    var registerWine: MyOwnedWine = MyOwnedWine()
    lazy var selectedDate: DateComponents = {
        guard let date = registerWine.getBuyDate() else {
            return Calendar.current.dateComponents([.year, .month, .day], from: Date())
        }
        return date
    }()
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

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
    
    @objc private func deleteNewWine() {
//        callDeleteAPI()
//        DispatchQueue.main.async {
//            self.navigationController?.popViewController(animated: true)
//        }
            let alert = UIAlertController(
                title: "테이스팅 노트 삭제",
                message: "정말 삭제하시겠습니까?",
                preferredStyle: .alert
            )
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
            self?.callDeleteAPI()
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc
    private func completeEdit() {
        callUpdateAPI(wineId: self.registerWine.wineId, price: checkPrice(), buyDate: checkDate())
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
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
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
            print("⚠️ userId가 UserDefaults에 없습니다.")
            return
        }
        
        Task {
            do {
                _ = try await networkService.deleteMyWine(myWineId: registerWine.wineId)
                try await APICallCounterManager.shared.createAPIControllerCounter(for: userId, controllerName: .myWine)
                try await APICallCounterManager.shared.incrementDelete(for: userId, controllerName: .myWine)
            } catch {
                print("\(error)\n 잠시후 다시 시도해주세요.")
            }
        }
    }
    
    private func callUpdateAPI(wineId: Int, price: Int?, buyDate: String?) {
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
            print("⚠️ userId가 UserDefaults에 없습니다.")
            return
        }
        
        let data = networkService.makeUpdateDTO(buyDate: buyDate, buyPrice: price)
        
        Task {
            do {
                _ = try await networkService.updateMyWine(myWineId: wineId, data: data)
                try await APICallCounterManager.shared.createAPIControllerCounter(for: userId, controllerName: .myWine)
                try await APICallCounterManager.shared.incrementPatch(for: userId, controllerName: .myWine)
            } catch {
                print("\(error)\n 잠시후 다시 시도해주세요.")
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
