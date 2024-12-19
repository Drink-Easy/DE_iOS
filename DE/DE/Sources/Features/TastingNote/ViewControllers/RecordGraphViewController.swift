//
//  RecordGraphViewController.swift
//  Drink-EG
//
//  Created by 이수현 on 11/18/24.
//

import UIKit

class RecordGraphViewController: UIViewController {

    let recordGraphView = RecordGraphView()
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(scrollView)
        view.backgroundColor = .white
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(recordGraphView)
        recordGraphView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(1325)
            make.width.equalTo(scrollView)
        }
    }

}
