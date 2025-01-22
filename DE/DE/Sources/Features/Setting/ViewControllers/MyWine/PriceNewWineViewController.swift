// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import SnapKit
import Then
// TODO : 도연
// TODO : 디테일 수정
// 버튼 활성화 기능 등 추가
// 기능 작업 더 해야함.

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

}
