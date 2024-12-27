// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

public class ChooseWineColorViewController: UIViewController, ColorStackViewDelegate {
    
    var selectedColor: UIColor?
    let chooseWineColor = ChooseWineColor()
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
        setupActions()
        setupDelegate()
    }
    
    func setupUI() {
        view.backgroundColor = AppColor.gray20
        
        view.addSubview(chooseWineColor)
        chooseWineColor.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupActions() {
        chooseWineColor.navView.backButton.addTarget(self, action: #selector(prevVC), for: .touchUpInside)
        chooseWineColor.nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
    }
    
    func setupDelegate() {
        chooseWineColor.colorStackView1.delegate = self
        chooseWineColor.colorStackView2.delegate = self
        chooseWineColor.colorStackView3.delegate = self
        chooseWineColor.colorStackView4.delegate = self
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
        guard let selectedColor = selectedColor, let hexColor = selectedColor.toHex() else {
            print("색상을 선택해주세요.")
            return
        }
        
        UserDefaults.standard.set(hexColor, forKey: "selectedColorHex")
        print("선택된 색상 헥스 코드 저장 완료: \(hexColor)")
        
        
        let nextVC = ChooseNoseViewController()
        nextVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func colorStackView(_ stackView: ColorStackView, didSelectColor color: UIColor) {
        selectedColor = color
    }
}
