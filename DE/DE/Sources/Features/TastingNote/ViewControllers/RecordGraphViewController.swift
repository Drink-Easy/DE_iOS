//
//  RecordGraphViewController.swift
//  Drink-EG
//
//  Created by 이수현 on 11/18/24.
//

import UIKit

public class RecordGraphViewController: UIViewController {

    let recordGraphView = RecordGraphView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view = recordGraphView
        setupActions()
    }
    
    func setupActions() {
        recordGraphView.navView.backButton.addTarget(self, action: #selector(prevVC), for: .touchUpInside)
        recordGraphView.nextButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
        let nextVC = RatingWineViewController()
        nextVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(nextVC, animated: true)
    }

}
