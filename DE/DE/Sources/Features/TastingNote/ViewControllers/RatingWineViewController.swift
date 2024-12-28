// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

public class RatingWineViewController: UIViewController {
    
    let ratingWineView = RatingWineView()
    private var ratingValue: Double = 2.5
    let navigationBarManager = NavigationBarManager()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = ratingWineView
        setupActions()
        setupNavigationBar()
    }
    
    func setupActions() {
        ratingWineView.saveButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        
        ratingWineView.ratingButton.didFinishTouchingCosmos = { [weak self] rating in
            guard let self = self else { return }
            self.updateRatingLabel(with: rating)
        }
    }
    
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: AppColor.gray80!
        )
    }
    
    private func updateRatingLabel(with rating: Double) {
        ratingValue = rating
        ratingWineView.ratingLabel.text = String(format: "%.1f / 5.0", rating)
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
        
        // UserDefaults에 저장
        let reviewText = ratingWineView.reviewTextField.text ?? ""
        let reviewRate = Int(ratingValue)
        
        UserDefaults.standard.set(reviewText, forKey: "review")
        UserDefaults.standard.set(reviewRate, forKey: "satisfaction")
        
        print("저장된 데이터: \(reviewText), \(reviewRate)")
        
        let nextVC = NoteListViewController()
        nextVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
