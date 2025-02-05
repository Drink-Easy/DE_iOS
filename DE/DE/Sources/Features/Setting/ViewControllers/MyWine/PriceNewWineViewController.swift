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
        setupActions()
        hideKeyboardWhenTappedAround()
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
        view.backgroundColor = AppColor.bgGray
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
        priceNewWineView.priceTextField.textField.addTarget(self, action: #selector(checkEmpty), for: .allEditingEvents)
    }
    
    @objc func nextVC() {
        guard let price = self.priceNewWineView.priceTextField.text, isValidInteger(price) else {
            let alert = UIAlertController(title: "", message: "가격을 숫자로만 입력해주세요.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        MyOwnedWineManager.shared.setPrice(price)
        Task {
            await callPostAPI()
        }
        
        DispatchQueue.main.async {
            guard let navigationController = self.navigationController else {
                return
            }
            
            // 🔹 네비게이션 스택에서 MyOwnedWineViewController 찾기
            if let targetIndex = navigationController.viewControllers.firstIndex(where: { $0 is MyOwnedWineViewController }) {
                let targetVC = navigationController.viewControllers[targetIndex]
                navigationController.popToViewController(targetVC, animated: true)
            } else {
                navigationController.popToRootViewController(animated: true) // 못 찾으면 루트로 이동
            }
        }
    }

    func isValidInteger(_ text: String) -> Bool {
        return Int(text) != nil
    }
    
    private func callPostAPI() async {
        guard let userId = UserDefaults.standard.value(forKey: "userId") as? Int else {
            print("⚠️ userId가 UserDefaults에 없습니다.")
            return
        }
        
        let wm = MyOwnedWineManager.shared
        let data = networkService.makePostDTO(wineId: wm.getWineId(), buyDate: wm.getBuyDate(), buyPrice: wm.getPrice())
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
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func checkEmpty() {
        guard let text = self.priceNewWineView.priceTextField.text else {
            priceNewWineView.nextButton.isEnabled(isEnabled: false)
            return
        }

        if text.isEmpty || text == "" {
            priceNewWineView.nextButton.isEnabled(isEnabled: false)
        } else {
            priceNewWineView.nextButton.isEnabled(isEnabled: true)
        }
    }
}
