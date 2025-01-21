// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network

public class ChangeRateViewController: UIViewController {
    
    let ratingWineView = ChangeRateView()
    private var ratingValue: Double = 2.5
    let navigationBarManager = NavigationBarManager()
    
    let noteService = TastingNoteService()
    let dto: TastingNoteResponsesDTO
    
    init(dto: TastingNoteResponsesDTO) {
        self.dto = dto
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = ratingWineView
        setupActions()
        setupNavigationBar()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ratingWineView.updateUI(dto: dto)
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
        callNotePatchRate(rating: ratingWineView.ratingButton.rating, review: ratingWineView.reviewTextField.text)
        dismiss(animated: true, completion: nil)
    }
    
    func callNotePatchRate(rating: Double, review: String) {
        let updateRequest = TastingNoteUpdateRequestDTO(
            color: nil,
            tastingDate: nil,
            sugarContent: nil,
            acidity: nil,
            tannin: nil,
            body: nil,
            alcohol: nil,
            addNoseList: nil,
            removeNoseList: nil,
            rating: rating,
            review: review
        )
        let patchDTO = TastingNotePatchRequestDTO(noteId: dto.noteId, body: updateRequest)
        noteService.patchNote(data: patchDTO, completion: {[weak self] result in
            guard let self = self else { return }
            switch result {
            case.success(let response):
                DispatchQueue.main.async {
                    print("PATCH 요청 성공: \(response)")
                }
            case.failure(let error):
                print(error)
            }
        })
    }
}
