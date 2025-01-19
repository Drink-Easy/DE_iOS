// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network

public class ChooseWineColorViewController: UIViewController {
    
    var selectedColor: UIColor?
    let chooseWineColor = ChooseWineColor()
    let navigationBarManager = NavigationBarManager()
    
    let wineName = UserDefaults.standard.string(forKey: "wineName")
    let wineSort = UserDefaults.standard.string(forKey: "wineSort")
    let wineArea = UserDefaults.standard.string(forKey: "wineArea")
    let wineImage = UserDefaults.standard.string(forKey: "wineImage")
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chooseWineColor.updateUI(wineName: wineName ?? "", wineSort: wineSort ?? "", imageUrl: wineImage ?? "", wineArea: wineArea ?? "")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
//        setupDelegate()
        setupNavigationBar()
    }
    
    func setupUI() {
        view.backgroundColor = AppColor.gray20
        
        view.addSubview(chooseWineColor)
        chooseWineColor.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupActions() {
        chooseWineColor.nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
    }
    
//    func setupDelegate() {
//        chooseWineColor.colorStackView1.delegate = self
//    }
    
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
