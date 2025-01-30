// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import CoreModule
import SwiftyToaster
import Network

public class NormalTextViewController: UIViewController {
    
    let networkService = MemberService()
    
    private let navigationBarManager = NavigationBarManager()
    
    private lazy var firstTextLabel = createLabel()
    private lazy var varietyTextLabel = createLabel()
    private lazy var sortTextLabel = createLabel()
    
    private let firstblurView = UIVisualEffectView()
    private let secblurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
//    private let secblurView = UIView().then {
//        $0.backgroundColor = AppColor.bgGray?.withAlphaComponent(0.3)
//    }
    private let thirdblurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
    
    lazy var nextButton = CustomButton(title: "추천 와인 확인하러 가기", isEnabled: true)
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        
        var varietyString = ""
        if UserSurveyManager.shared.getIntersectionVarietyData().count > 2 {
            let varietyData = UserSurveyManager.shared.getIntersectionVarietyData()
            varietyString = formatText(from: varietyData)
        } else {
            let varietyData = UserSurveyManager.shared.getUnionVarietyData()
            varietyString = formatText(from: varietyData)
        }
        
        var sortString = ""
        if UserSurveyManager.shared.getIntersectionSortData().count > 2 {
            let sortData = UserSurveyManager.shared.getIntersectionSortData()
            sortString = formatText(from: sortData)
        } else {
            let sortData = UserSurveyManager.shared.getUnionSortData()
            sortString = formatText(from: sortData)
        }
        
        // ✨ NSAttributedString 스타일 적용
        firstTextLabel.attributedText = setStyledText(
            mainText: "\(UserSurveyManager.shared.name) ",
            highlightText: "님께\n어울리는 와인은",
            mainFontSize: 34,
            highlightFontSize: 26
        )
        
        varietyTextLabel.attributedText = setStyledText(
            mainText: varietyString,
            highlightText: " 품종의",
            mainFontSize: 34,
            highlightFontSize: 26
        )
        
        sortTextLabel.attributedText = setStyledText(
            mainText: sortString,
            highlightText: " 와인입니다.",
            mainFontSize: 34,
            highlightFontSize: 26
        )
        
        // 🚀 초기 설정
        nextButton.isHidden = true  // 버튼을 처음엔 숨김

        setUI()
        setupNavigationBar()
        
        // 🔥 3초 뒤 첫 번째 블러 제거 → 2초 뒤 두 번째 → 2초 뒤 세 번째 → 2초 뒤 버튼 표시
        startBlurSequence()
    }

    /// 🔥 블러뷰를 순차적으로 변경하는 애니메이션
    private func startBlurSequence() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // Step 1: firstBlurView & thirdBlurView 블러 적용, secBlurView 블러 해제
            self.animateBlur(to: self.firstblurView, apply: true)
            self.animateBlur(to: self.thirdblurView, apply: true)
            self.animateBlur(to: self.secblurView, apply: false)

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                // Step 2: firstBlurView & secBlurView 블러 적용, thirdBlurView 블러 해제
                self.animateBlur(to: self.firstblurView, apply: true)
                self.animateBlur(to: self.secblurView, apply: true)
                self.animateBlur(to: self.thirdblurView, apply: false)

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    // Step 3: 모든 블러 해제
                    self.animateBlur(to: self.firstblurView, apply: false)
                    self.animateBlur(to: self.secblurView, apply: false)
                    self.animateBlur(to: self.thirdblurView, apply: false)

                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        // Step 4: 버튼 부드럽게 등장
                        self.nextButton.isHidden = false
                        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut) {
                            self.nextButton.alpha = 1
                        }
                    }
                }
            }
        }
    }

    /// ✨ 부드러운 블러 애니메이션 (점진적으로 블러 효과 적용/해제)
    private func animateBlur(to blurView: UIVisualEffectView, apply: Bool) {
        let effect: UIBlurEffect? = apply ? UIBlurEffect(style: .systemMaterial) : nil
        let animator = UIViewPropertyAnimator(duration: 1.5, curve: .easeInOut) {
            blurView.effect = effect
        }
        animator.startAnimation()
    }
    
    /// ✨ 부드럽게 블러뷰 제거하는 애니메이션
    private func animateBlurRemoval(_ blurView: UIVisualEffectView) {
        UIView.animate(withDuration: 1.5, animations: {
            blurView.alpha = 0
        }) { _ in
            blurView.removeFromSuperview()
        }
    }
    

    /// ✨ NSAttributedString을 사용하여 텍스트 스타일링
    private func setStyledText(mainText: String, highlightText: String, mainFontSize: CGFloat, highlightFontSize: CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: mainText + highlightText)
        
        let mainAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.ptdSemiBoldFont(ofSize: mainFontSize),
            .foregroundColor: AppColor.purple70!
        ]
        
        let highlightAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.ptdRegularFont(ofSize: highlightFontSize),
            .foregroundColor: AppColor.black!
        ]
        
        attributedString.addAttributes(mainAttributes, range: (mainText as NSString).range(of: mainText))
        attributedString.addAttributes(highlightAttributes, range: (mainText + highlightText as NSString).range(of: highlightText))
        
        return attributedString
    }

    /// ✨ 텍스트 포맷팅 함수 (3개까지만 표시)
    private func formatText(from data: [String]) -> String {
        return data.prefix(3).joined(separator: ", ")
    }
    
    func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    /// ✨ 공통된 라벨 스타일 생성
    private func createLabel() -> UILabel {
        return UILabel().then {
            $0.textAlignment = .left
            $0.numberOfLines = 2
            $0.lineBreakMode = .byWordWrapping
        }
    }
    
    func setUI() {
        [firstTextLabel, varietyTextLabel, sortTextLabel, firstblurView, secblurView, thirdblurView, nextButton].forEach { view.addSubview($0) }
        
        firstTextLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(120))
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(35))
        }
        
        firstblurView.snp.makeConstraints { make in
            make.top.equalTo(firstTextLabel).inset(-DynamicPadding.dynamicValue(15))
            make.bottom.equalTo(firstTextLabel).offset(DynamicPadding.dynamicValue(15))
            make.leading.trailing.equalToSuperview()
        }
        
        varietyTextLabel.snp.makeConstraints { make in
            make.top.equalTo(firstTextLabel.snp.bottom).offset(DynamicPadding.dynamicValue(30))
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(35))
        }
        
        secblurView.snp.makeConstraints { make in
            make.top.equalTo(varietyTextLabel).inset(-DynamicPadding.dynamicValue(15))
            make.bottom.equalTo(varietyTextLabel).offset(DynamicPadding.dynamicValue(15))
            make.leading.trailing.equalToSuperview()
        }
        
        sortTextLabel.snp.makeConstraints { make in
            make.top.equalTo(varietyTextLabel.snp.bottom).offset(DynamicPadding.dynamicValue(30))
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(35))
        }
        
        thirdblurView.snp.makeConstraints { make in
            make.top.equalTo(sortTextLabel).inset(-DynamicPadding.dynamicValue(15))
            make.bottom.equalTo(sortTextLabel).offset(DynamicPadding.dynamicValue(15))
            make.leading.trailing.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(28.0))
            make.bottom.equalToSuperview().inset(DynamicPadding.dynamicValue(42.0))
        }
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func nextButtonTapped() {
        // UI 전환
        DispatchQueue.main.async {
            let homeTabBarController = MainTabBarController()
            homeTabBarController.userName = UserSurveyManager.shared.name
            SelectLoginTypeVC.keychain.set(false, forKey: "isFirst")
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = homeTabBarController
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
            }
        }
    }
    
    func setDTO() {
        UserSurveyManager.shared.setNewbieResult()
        
        
    }
}
