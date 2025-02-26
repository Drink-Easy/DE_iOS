// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network

// 5번 선택 뷰컨 테이스팅 노트 : 레이팅, 리뷰

public class RatingWineViewController: UIViewController, FirebaseTrackable {
    public var screenName: String = Tracking.VC.tnRatingWineVC
    
    lazy var rView = RatingWineView()
    private var ratingValue: Double = 2.5
    
    let navigationBarManager = NavigationBarManager()

    let networkService = TastingNoteService()
    let tnManager = NewTastingNoteManager.shared
    let wineData = TNWineDataManager.shared
    private let errorHandler = NetworkErrorHandler()
    
    let textViewPlaceHolder = "추가로 기록하고 싶은 내용을 작성해 보세요!"
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
        rView.header.setTitleLabel(wineData.wineName)
        rView.infoView.image.sd_setImage(with: URL(string: wineData.imageUrl))
        rView.infoView.countryContents.text = wineData.country + ", " + wineData.region
        rView.infoView.kindContents.text = wineData.sort
        rView.infoView.typeContents.text = wineData.variety.replacingOccurrences(of: " ,", with: ",")
        self.view.addSubview(indicator)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.view.addSubview(indicator)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        setConstraints()
        setupActions()
        
        setupNavigationBar()
        addExtendedBackgroundView()
        hideKeyboardWhenTappedAround()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
    }

    private func addExtendedBackgroundView() {
        // 네비게이션 바와 Safe Area를 포함한 배경 뷰 추가
        let backgroundView = UIView()
        backgroundView.backgroundColor = AppColor.bgGray
        view.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
    
    
    func setConstraints() {
        view.addSubview(rView)
        rView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(10))
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
            make.bottom.equalToSuperview()
        }
    }
    
    func setupActions() {
        rView.saveButton.addTarget(self, action: #selector(createTN), for: .touchUpInside)
        
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
    
    @objc func createTN() {
        self.logButtonClick(screenName: self.screenName,
                            buttonName: Tracking.ButtonEvent.createBtnTapped,
                       fileName: #file)
        
        var reviewString = ""
        if rView.reviewBody.text == textViewPlaceHolder {
            reviewString = ""
        } else {
            reviewString = rView.reviewBody.text ?? ""
        }
        
        tnManager.saveRating(ratingValue)
        tnManager.saveReview(reviewString)
        self.view.showBlockingView()
        Task {
            do {
                try await postCreateTastingNote()
                tnManager.resetData()
                wineData.resetData()
                NoseManager.shared.resetAllScents()
                self.view.hideBlockingView()
                navigationController?.popToRootViewController(animated: true)
            } catch {
                self.view.hideBlockingView()
                errorHandler.handleNetworkError(error, in: self)
            }
        }
    }
    
    private func postCreateTastingNote() async throws {
        let createNoteDTO = networkService.makePostNoteDTO(wineId: wineData.wineId, color: tnManager.color, tasteDate: tnManager.tasteDate, sugarContent: tnManager.sugarContent, acidity: tnManager.acidity, tannin: tnManager.tannin, body: tnManager.body, alcohol: tnManager.alcohol, nose: tnManager.nose, rating: tnManager.rating, review: tnManager.review)
        
        let _ = try await networkService.postNote(data: createNoteDTO)
    }
    
    @objc func keyboardDown() {
        self.rView.transform = .identity
    }
    
    @objc func keyboardUp(notification:NSNotification) {
        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
           let keyboardRectangle = keyboardFrame.cgRectValue
            
            UIView.animate(
                withDuration: 0.3
                , animations: {
                    self.rView.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
                }
            )
        }
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
        
        

        // 1️⃣ 글자 수 제한 (500자)
        if newString.count > 500 {
            showToastMessage(message: "500자 이하의 리뷰만 가능해요.", yPosition: view.frame.height * 0.75)
            rView.saveButton.isEnabled(isEnabled: false)
            return false
        }

        // 2️⃣ 비속어 필터링
        let currentFilePath = URL(fileURLWithPath: #file)
        let currentDirectory = currentFilePath.deletingLastPathComponent()
        let badWordFilePath = currentDirectory
            .deletingLastPathComponent() // ViewControllers/
            .deletingLastPathComponent() // TastingNote/
            .deletingLastPathComponent() // Features/
            .deletingLastPathComponent() // Sources/
            .appendingPathComponent("BadWord.txt")
        
        let nicknameFilter = TextFilter(filePath: badWordFilePath.path)
        
        if nicknameFilter.checkFWords(newString) { // 비속어 감지
            showToastMessage(message: "비속어를 사용할 수 없어요.", yPosition: view.frame.height * 0.75)
            rView.saveButton.isEnabled(isEnabled: false)
            return false
        }
        rView.saveButton.isEnabled(isEnabled: true)
        return true
    }
}
