// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network

public class EditRateViewController: UIViewController {
    
    lazy var rView = OnlyRateView()
    private var ratingValue: Double = 2.5
    let navigationBarManager = NavigationBarManager()
    
    let noteService = TastingNoteService()
    let tnManger = NewTastingNoteManager.shared
    let wineData = TNWineDataManager.shared
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        rView.header.setTitleLabel(wineData.wineName)
//        rView.infoView.countryContents.text = wineData.country + ", " + wineData.region
//        rView.infoView.kindContents.text = wineData.sort
//        rView.infoView.typeContents.text = wineData.variety
        rView.header.setTitleLabel("디자인 테스트")
        rView.infoView.countryContents.text = "디자인" + ", " + "테스트"
        rView.infoView.kindContents.text = "테스트"
        rView.infoView.typeContents.text = "테스트"
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        setConstraints()
        setupActions()
        
        setupNavigationBar()
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
        rView.saveButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        
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
        ratingValue = rating
        rView.setRate(rating)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
        // Call patch api
        navigationController?.popViewController(animated: true)
    }
    
}
