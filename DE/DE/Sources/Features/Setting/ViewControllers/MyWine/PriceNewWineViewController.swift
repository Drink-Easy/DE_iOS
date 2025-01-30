// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import SnapKit
import Then
import Network
// 기기대응 완료
// 보유와인 가격 입력

class PriceNewWineViewController: UIViewController {

    let priceNewWineView = MyWinePriceView()
    let navigationBarManager = NavigationBarManager()
    let networkService = MyWineService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupNavigationBar()
    }
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupUI() {
        priceNewWineView.setWineName(MyOwnedWineManager.shared.getWineName())
        
        view.addSubview(priceNewWineView)
        priceNewWineView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(10))
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupNavigationBar() {
        navigationBarManager.setTitle(to: navigationItem, title: "", textColor: AppColor.black!)
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC)
        )
    }
    
    func setupActions() {
        priceNewWineView.nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        priceNewWineView.priceTextField.textField.addTarget(self, action: #selector(checkEmpty), for: .editingChanged)
    }
    
    @objc func nextVC() {
        guard let price = self.priceNewWineView.priceTextField.text else { return }
        MyOwnedWineManager.shared.setPrice(price)
        
        callPostAPI()
        
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
            guard let navigationController = self.navigationController else { return }
            if let targetIndex = navigationController.viewControllers.firstIndex(where: { $0 is MyOwnedWineViewController }) {
                let newStack = Array(navigationController.viewControllers[...targetIndex])
                navigationController.setViewControllers(newStack, animated: true)
            }
        }
    }
    
    private func callPostAPI() {
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
            print("⚠️ userId가 UserDefaults에 없습니다.")
            return
        }
        
        let wm = MyOwnedWineManager.shared
        let data = networkService.makePostDTO(wineId: wm.getWineId(), buyDate: wm.getBuyDate(), buyPrice: wm.getPrice())
        Task {
            do {
                // 데이터 전송
                _ = try await networkService.postMyWine(data: data)
                
                // 데이터 전송 성공 시, 보유와인 콜카운터 생성 및 post +1
                try await APICallCounterManager.shared.createAPIControllerCounter(for: userId, controllerName: .myWine)
                try await APICallCounterManager.shared.incrementPost(for: userId, controllerName: .myWine)
            } catch {
                print("\(error)\n 잠시후 다시 시도해주세요.")
            }
        }
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func checkEmpty() {
        if ((self.priceNewWineView.priceTextField.text?.isEmpty) != nil) || self.priceNewWineView.priceTextField.text == "" {
            priceNewWineView.nextButton.isEnabled(isEnabled: false)
        } else {
            priceNewWineView.nextButton.isEnabled(isEnabled: true)
        }
    }

}
