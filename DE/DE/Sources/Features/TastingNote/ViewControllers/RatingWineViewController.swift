// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network

public class RatingWineViewController: UIViewController {
    
    let ratingWineView = RatingWineView()
    private var ratingValue: Double = 2.5
    let navigationBarManager = NavigationBarManager()
    
    let noteService = TastingNoteService()
    
    let wineName = UserDefaults.standard.string(forKey: "wineName")
    let wineArea = UserDefaults.standard.string(forKey: "wineArea")
    let wineImage = UserDefaults.standard.string(forKey: "wineImage")
    let wineSort = UserDefaults.standard.string(forKey: "wineSort")
    
    let userDefaultsKeys = ["wineName", "wineId", "wineSort", "wineArea", "wineImage", "tasteDate", "color", "nose", "sliderValues", "rating", "review"]
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.ratingWineView.updateUI(wineName: self.wineName ?? "", wineSort: self.wineSort ?? "", wineArea: self.wineArea ?? "", wineImage: self.wineImage ?? "")
        }
    }
    
    func callPost() {
        
        func getValue<T>(forKey key: String) -> T? {
            return UserDefaults.standard.value(forKey: key) as? T
        }
        
        func getString(forKey key: String) -> String? {
            return UserDefaults.standard.string(forKey: key)
        }
        
        guard
            let wineId: Int = getValue(forKey: "wineId"),
            let tasteDate = getString(forKey: "tasteDate"),
            let color = getString(forKey: "color"),
            let noseData = UserDefaults.standard.data(forKey: "nose"),
            let sliderValue = UserDefaults.standard.dictionary(forKey: "sliderValues") as? [String: Int],
            let rating: Double = getValue(forKey: "rating"),
            let review = getString(forKey: "review")
        else {
            print("필수 값이 누락되었습니다.")
            return
        }
        
        let decoder = JSONDecoder()
        guard let decodedNose = try? decoder.decode([String: [NoseModel]].self, from: noseData) else {
            print("디코딩 실패")
            return
        }
        
        let noseArray: [String] = decodedNose.flatMap { $0.value.map { $0.type } }
        
        let postDTO = noteService.makePostNoteDTO(
            wineId: wineId,
            color: color,
            tasteDate: tasteDate,
            sugarContent: sliderValue["Sweetness"] ?? 0,
            acidity: sliderValue["Acidity"] ?? 0,
            tannin: sliderValue["Tannin"] ?? 0,
            body: sliderValue["Body"] ?? 0,
            alcohol: sliderValue["Alcohol"] ?? 0,
            nose: noseArray,
            rating: rating,
            review: review
        )
        
        noteService.postNote(data: postDTO, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let str):
                for i in userDefaultsKeys {
                    UserDefaults.standard.removeObject(forKey: "\(i)")
                }
                print("UserDefaults 값 삭제 !!!!!!")
                DispatchQueue.main.async {
                    let nextVC = NoteListViewController()
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            case.failure(let error):
                print(error)
            }
        } )
    }
    
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
            action: #selector(prevVC)
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
        UserDefaults.standard.set(reviewRate, forKey: "rating")
        
        print("저장된 데이터: \(reviewText), \(reviewRate)")
        
        callPost()
    }
}
