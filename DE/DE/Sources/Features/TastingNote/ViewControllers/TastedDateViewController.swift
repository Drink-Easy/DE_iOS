//
//  TastedDateViewController.swift
//  Drink-EG
//
//  Created by 이수현 on 10/30/24.
//

import UIKit

class TastedDateViewController: UIViewController {

    let tastedDateView = TastedDateView()
    // let selection = UICalendarSelectionSingleDate(delegate: self)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tastedDateView)
        tastedDateView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
