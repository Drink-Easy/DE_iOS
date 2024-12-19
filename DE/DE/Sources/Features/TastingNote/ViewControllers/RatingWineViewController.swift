//
//  RatingWineViewController.swift
//  Drink-EG
//
//  Created by 이수현 on 10/30/24.
//

import UIKit

class RatingWineViewController: UIViewController {

    let wineView = WineInfoView()
    let scrollView = UIScrollView()
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func setupUI() {
        
        view.addSubview(scrollView)
        view.backgroundColor = UIColor(hex: "F8F8FA")
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(wineView)
        wineView.backgroundColor = UIColor(hex: "F8F8FA")
        wineView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView)
            // make.bottom.equalTo(scrollView.snp.bottom).offset(-10)
            make.height.equalTo(1000)
        }
    }
    
}
