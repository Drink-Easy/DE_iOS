// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network

public class RatingWineViewController: UIViewController {
    
    lazy var rView = RatingWineView()
    private var ratingValue: Double = 2.5
    let navigationBarManager = NavigationBarManager()
    
    let noteService = TastingNoteService()
    let tnManger = NewTastingNoteManager.shared
    let wineData = TNWineDataManager.shared
    
    let textViewPlaceHolder = "추가로 기록하고 싶은 내용을 작성해 보세요!"
    
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
        
        rView.reviewBody.delegate = self
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
        rView.ratingLabel.text = String(format: "%.1f / 5.0", rating)
    }
    
    @objc func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextVC() {
        // Call post api
    }
}

extension RatingWineViewController : UITextViewDelegate {
    public func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = AppColor.gray90!
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = AppColor.gray90!
        }
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)

        let characterCount = newString.count
        guard characterCount <= 500 else { return false }
        // TODO : 경고창 띄우기?
        // alertview?

        return true
    }
}
