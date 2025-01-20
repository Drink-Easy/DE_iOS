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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
//        rView.header.setTitleLabel(wineData.wineName)
//        rView.infoView.countryContents.text = wineData.country + ", " + wineData.region
//        rView.infoView.kindContents.text = wineData.sort
//        rView.infoView.typeContents.text = wineData.variety
        rView.header.setTitleLabel("디자인 테스트")
        rView.infoView.countryContents.text = "디자인" + ", " + "테스트"
        rView.infoView.kindContents.text = "테스트"
        rView.infoView.typeContents.text = "테스트"
        
        
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        rView.saveButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        
        rView.ratingButton.didFinishTouchingCosmos = { [weak self] rating in
            guard let self = self else { return }
            self.updateRatingLabel(with: rating)
        }
        
        rView.reviewBody.delegate = self
        
        // 탭 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // 다른 제스처(버튼 클릭 등)를 방해하지 않음
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: AppColor.gray80!
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
        // Call post api
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

        let characterCount = newString.count
        guard characterCount <= 500 else { return false }
        // TODO : 경고창 띄우기?
        // alertview?

        return true
    }
}
