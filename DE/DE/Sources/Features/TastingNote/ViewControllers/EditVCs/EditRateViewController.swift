// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network

public class EditRateViewController: UIViewController, FirebaseTrackable {
    public var screenName: String = Tracking.VC.editRateVC
    
    lazy var rView = OnlyRateView()
    public var ratingValue: Double = 2.5
    let navigationBarManager = NavigationBarManager()
    
    let networkService = TastingNoteService()
    let tnManager = NewTastingNoteManager.shared
    let wineData = TNWineDataManager.shared
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateRatingLabel(with: tnManager.rating)
        
        rView.header.setTitleLabel(wineData.wineName)
        rView.infoView.image.sd_setImage(with: URL(string: wineData.imageUrl))
        rView.infoView.countryContents.text = wineData.country + ", " + wineData.region
        rView.infoView.kindContents.text = wineData.sort
        rView.infoView.typeContents.text = wineData.variety.replacingOccurrences(of: " ,", with: ",")
        rView.ratingButton.rating = tnManager.rating
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(indicator)
        view.backgroundColor = AppColor.bgGray
        setConstraints()
        setupActions()
        setupNavigationBar()
        hideKeyboardWhenTappedAround()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
    }
    
    func setConstraints() {
        view.addSubview(rView)
        rView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
        }
    }
    
    func setupActions() {
        rView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        
        rView.ratingButton.didFinishTouchingCosmos = { [weak self] rating in
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
        
        self.navigationController?.navigationBar.backgroundColor = AppColor.bgGray
    }
    
    private func updateRatingLabel(with rating: Double) {
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.tnRateBtnTapped, fileName: #file)
        ratingValue = rating
        rView.setRate(rating)
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveButtonTapped() {
        logButtonClick(screenName: self.screenName,
                            buttonName: Tracking.ButtonEvent.saveBtnTapped,
                       fileName: #file)
        callUpdateAPI()
    }
    
    private func callUpdateAPI() {
        let updateData = networkService.makeUpdateNoteBodyDTO(satisfaction: ratingValue)
        
        let tnData = networkService.makeUpdateNoteDTO(noteId: tnManager.noteId, body: updateData)
        Task {
            do {
                self.view.showBlockingView()
                let _ = try await networkService.patchNote(data: tnData)
                self.view.hideBlockingView()
                navigationController?.popViewController(animated: true)
            }
        }
    }
}
