// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network

public class ChooseWineColorViewController: UIViewController {
    
    var selectedColor: UIColor?
    
    let navigationBarManager = NavigationBarManager()
    let colorView = SelectColorView()
    let wineData = TNWineDataManager.shared
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        colorView.header.setTitleLabel(wineData.wineName)
        colorView.infoView.countryContents.text = wineData.country + "," + wineData.region
        colorView.infoView.kindContents.text = wineData.sort
        colorView.infoView.typeContents.text = wineData.variety
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupNavigationBar()
    }
    
    func setupUI() {
        view.backgroundColor = AppColor.gray20
    }
    
    func setupActions() {
        chooseWineColor.nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
    }

    
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: AppColor.gray80!
        )
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
        guard let selectedColor = selectedColor, let hexColor = selectedColor.toHex() else {
            print("색상을 선택해주세요.")
            return
        }
        
        UserDefaults.standard.set(hexColor, forKey: "color")
        print("선택된 색상 헥스 코드 저장 완료: \(hexColor)")
        
        
        let nextVC = ChooseNoseViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }

}
