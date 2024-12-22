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
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(hex: "#F8F8FA")
        
        view.addSubview(chooseWineColor)
        chooseWineColor.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    

}
