// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Network

public class EditReviewViewController: UIViewController, FirebaseTrackable {
    public var screenName: String = Tracking.VC.editReviewVC
    
    lazy var rView = OnlyReviewView()
    let navigationBarManager = NavigationBarManager()
    private let errorHandler = NetworkErrorHandler()
    let networkService = TastingNoteService()
    let tnManager = NewTastingNoteManager.shared
    let wineData = TNWineDataManager.shared
    let textViewPlaceHolder = "추가로 기록하고 싶은 내용을 작성해 보세요!"
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(indicator)
        //        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        //           NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
        rView.setWineName(wineData.wineName)
        rView.infoView.image.sd_setImage(with: URL(string: wineData.imageUrl))
        rView.infoView.countryContents.text = wineData.country + ", " + wineData.region
        rView.infoView.kindContents.text = wineData.sort
        rView.infoView.typeContents.text = wineData.variety.replacingOccurrences(of: " ,", with: ",")
        rView.reviewBody.text = tnManager.review
    }
    
    //    public override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    //        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    //    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        setConstraints()
        setupActions()
        
        setupNavigationBar()
        //        addExtendedBackgroundView()
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
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
        }
    }
    
    func setupActions() {
        rView.saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
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
        var reviewString = ""
        if rView.reviewBody.text == textViewPlaceHolder {
            reviewString = ""
        } else {
            reviewString = rView.reviewBody.text ?? ""
        }
        
        let updateData = networkService.makeUpdateNoteBodyDTO(review: reviewString)
        
        let tnData = networkService.makeUpdateNoteDTO(noteId: tnManager.noteId, body: updateData)
        self.view.showBlockingView()
        Task {
            do {
                let _ = try await networkService.patchNote(data: tnData)
                self.view.hideBlockingView()
                navigationController?.popViewController(animated: true)
            } catch {
                self.view.hideBlockingView()
                errorHandler.handleNetworkError(error, in: self)
            }
        }
    }
    
    
    
    //    @objc func keyboardDown() {
    //        self.rView.transform = .identity
    //    }
    //
    //    @objc func keyboardUp(notification:NSNotification) {
    //        if let keyboardFrame:NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
    //           let keyboardRectangle = keyboardFrame.cgRectValue
    //
    //            UIView.animate(
    //                withDuration: 0.3
    //                , animations: {
    //                    self.rView.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
    //                }
    //            )
    //        }
    //    }
}

extension EditReviewViewController : UITextViewDelegate {
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
