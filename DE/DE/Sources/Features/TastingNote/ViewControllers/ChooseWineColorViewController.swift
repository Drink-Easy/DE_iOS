//
//  DescriptionViewController.swift
//  Drink-EG
//
//  Created by 이수현 on 11/11/24.
//

import UIKit

public class ChooseWineColorViewController: UIViewController {

    let chooseWineColor = ChooseWineColor()
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupActions()
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(hex: "#F8F8FA")
        
        view.addSubview(chooseWineColor)
        chooseWineColor.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupActions() {
        chooseWineColor.navView.backButton.addTarget(self, action: #selector(prevVC), for: .touchUpInside)
        chooseWineColor.nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
        let nextVC = ChooseNoseViewController()
        nextVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
