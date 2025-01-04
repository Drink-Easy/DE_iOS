// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network

public class ChooseWineColorViewController: UIViewController, ColorStackViewDelegate {
    
    var selectedColor: UIColor?
    let chooseWineColor = ChooseWineColor()
    let navigationBarManager = NavigationBarManager()
    let dto: SearchWineResponseDTO
    
    init(data: SearchWineResponseDTO) {
        self.dto = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chooseWineColor.updateUI(dto)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupDelegate()
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
    
    func setupDelegate() {
        chooseWineColor.colorStackView1.delegate = self
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
    
    func colorStackView(_ stackView: ColorStackView, didSelectColor color: UIColor?) {
        selectedColor = color
    }
}
