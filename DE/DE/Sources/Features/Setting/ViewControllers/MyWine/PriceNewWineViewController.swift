// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import SnapKit
import Then

// 보유와인 가격 입력

class PriceNewWineViewController: UIViewController {

    let priceNewWineView = MyWinePriceView()
    let navigationBarManager = NavigationBarManager()
    
    public var selectDate : String?
    let wineData = TNWineDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupNavigationBar()
    }
    
    func setupUI() {
        priceNewWineView.setWineName("와인이름데이터넘겨주기")
        priceNewWineView.setWineName(wineData.wineName)
        
        view.addSubview(priceNewWineView)
        priceNewWineView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(24)
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
        // api 호출
        // call count 처리도 해주기
        
        // 리스트 화면으로 돌아가기
        Task {
            self.navigationController?.popViewController(animated: true)
            guard let navigationController = self.navigationController else { return }
            if let targetIndex = navigationController.viewControllers.firstIndex(where: { $0 is MyOwnedWineViewController }) {
                 let newStack = Array(navigationController.viewControllers[...targetIndex])
                 navigationController.setViewControllers(newStack, animated: true)
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
