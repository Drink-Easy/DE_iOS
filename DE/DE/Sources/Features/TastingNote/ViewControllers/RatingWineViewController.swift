//
//  RatingWineViewController.swift
//  Drink-EG
//
//  Created by 이수현 on 10/30/24.
//

import UIKit

public class RatingWineViewController: UIViewController {
    
    let ratingWineView = RatingWineView()
    private var ratingValue: Double = 2.5
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = ratingWineView
        setupActions()
    }
    
    func setupActions() {
        ratingWineView.navView.backButton.addTarget(self, action: #selector(prevVC), for: .touchUpInside)
        ratingWineView.saveButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        
        ratingWineView.ratingButton.didFinishTouchingCosmos = { [weak self] rating in
            guard let self = self else { return }
            self.updateRatingLabel(with: rating)
        }
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
