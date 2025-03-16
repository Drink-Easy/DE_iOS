// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import CoreModule
import SwiftyToaster
import Network

public class NormalTextViewController: UIViewController, FirebaseTrackable {
    public var screenName: String = Tracking.VC.NormalTextVC
    
    let networkService = MemberService()
    let userMng = UserSurveyManager.shared
    
    private let navigationBarManager = NavigationBarManager()
    private let errorHandler = NetworkErrorHandler()
    
    private lazy var firstTextLabel = createLabel()
    private lazy var varietyTextLabel = createLabel()
    private lazy var sortTextLabel = createLabel()

    
    private let firblurView = UIView().then {
        $0.backgroundColor = AppColor.bgGray?.withAlphaComponent(1)
    }
    private let secblurView = UIView().then {
        $0.backgroundColor = AppColor.bgGray?.withAlphaComponent(1)
    }
    private let thirdblurView = UIView().then {
        $0.backgroundColor = AppColor.bgGray?.withAlphaComponent(1)
    }
    
    lazy var nextButton = CustomButton(title: "추천 와인 확인하러 가기", isEnabled: true)
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.view.addSubview(indicator)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logScreenView(fileName: #file)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        
        let (varietyString, sortString) = calculateResult()

        
        // ✨ NSAttributedString 스타일 적용
        firstTextLabel.attributedText = setStyledText(
            mainText: "\(UserSurveyManager.shared.name) ",
            highlightText: "님께\n어울리는 와인은",
            mainFontSize: 32,
            highlightFontSize: 26
        )
        
        varietyTextLabel.attributedText = setStyledText(
            mainText: varietyString,
            highlightText: " 품종의",
            mainFontSize: 32,
            highlightFontSize: 26
        )
        
        sortTextLabel.attributedText = setStyledText(
            mainText: sortString,
            highlightText: " 와인입니다.",
            mainFontSize: 32,
            highlightFontSize: 26
        )
        
        nextButton.isHidden = true  // 버튼을 처음엔 숨김

        setUI()
        setupNavigationBar()
        
        startAlphaAnimationSequence()
    }
    
    func calculateResult() -> (String, String ){
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
            let sortData = UserSurveyManager.shared.getIntersectionSortData().sorted { $0.count <= $1.count }
            sortString = formatText(from: sortData)
        } else {
            let sortData = UserSurveyManager.shared.getUnionSortData().sorted { $0.count <= $1.count }
            sortString = formatText(from: sortData)
        }
        return (varietyString, sortString)
    }

    private func startAlphaAnimationSequence() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.animateAlphaChange(view: self.firblurView)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.animateAlphaChange(view: self.secblurView)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.animateAlphaChange(view: self.thirdblurView)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.nextButton.isHidden = false
                        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut) {
                            self.nextButton.alpha = 1
                        }
                    }
                }
            }
        }
    }
    
    private func animateAlphaChange(view: UIView) {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut) {
            view.alpha = 0.0
        }
    }

    private func setStyledText(
        mainText: String,
        highlightText: String,
        mainFontSize: CGFloat,
        highlightFontSize: CGFloat,
        lineSpacing: CGFloat = 2
    ) -> NSAttributedString {
        
        let fullText = mainText + highlightText
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing // ✅ 행간 추가
        
        let mainAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.ptdSemiBoldFont(ofSize: mainFontSize),
            .foregroundColor: AppColor.purple70!,
            .paragraphStyle: paragraphStyle // ✅ 모든 텍스트에 행간 적용
        ]
        
        let highlightAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.ptdRegularFont(ofSize: highlightFontSize),
            .foregroundColor: AppColor.black!,
            .paragraphStyle: paragraphStyle // ✅ 모든 텍스트에 행간 적용
        ]
        
        attributedString.addAttributes(mainAttributes, range: (fullText as NSString).range(of: mainText))
        attributedString.addAttributes(highlightAttributes, range: (fullText as NSString).range(of: highlightText))
        
        return attributedString
    }

    /// ✨ 텍스트 포맷팅 함수 (3개까지만 표시)
    private func formatText(from data: [String]) -> String {
//        var innerData = data.sorted{ $0.count <= $1.count }
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
            $0.numberOfLines = 3
            $0.lineBreakMode = .byWordWrapping
        }
    }
    
    func setUI() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        [firstTextLabel, varietyTextLabel, sortTextLabel, firblurView, secblurView, thirdblurView, nextButton].forEach { view.addSubview($0) }
        
        firstTextLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(120))
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(35))
        }
        
        firblurView.snp.makeConstraints { make in
            make.edges.equalTo(firstTextLabel)
        }

        varietyTextLabel.snp.makeConstraints { make in
            make.top.equalTo(firstTextLabel.snp.bottom).offset(DynamicPadding.dynamicValue(30))
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(35))
        }
        
        secblurView.snp.makeConstraints { make in
            make.edges.equalTo(varietyTextLabel)
        }
        
        sortTextLabel.snp.makeConstraints { make in
            make.top.equalTo(varietyTextLabel.snp.bottom).offset(DynamicPadding.dynamicValue(30))
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(35))
        }
        
        thirdblurView.snp.makeConstraints { make in
            make.edges.equalTo(sortTextLabel)
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
        logButtonClick(screenName: screenName, buttonName: Tracking.ButtonEvent.goToHomeBtnTapped, fileName: #file)
        self.view.showBlockingView()
        callPatchAPI()
    }
    
    func setDTO() -> MemberRequestDTO {
        let userMng = UserSurveyManager.shared
        userMng.setNewbieResult()
        
        return networkService.makeMemberInfoRequestDTO(name: userMng.name,
                                                               isNewbie: userMng.isNewbie,
                                                               monthPrice: userMng.monthPrice,
                                                               wineSort: userMng.wineSort,
                                                               wineArea: userMng.wineArea,
                                                               wineVariety: userMng.wineVariety)

    }
    
    func callPatchAPI() {
        Task {
            do {
                async let imageUpload: String? = {
                    if let profileImage = await userMng.imageData {
                        return try await networkService.postImgAsync(image: profileImage)
                    }
                    return nil
                }()
                
                async let userInfoUpdate = try networkService.postUserInfoAsync(body: setDTO())

                // ✅ 두 개의 네트워크 요청이 모두 끝날 때까지 기다림
                _ = try await (imageUpload, userInfoUpdate)
                userMng.resetData()

                // UI 변경
                DispatchQueue.main.async {
                    let homeTabBarController = MainTabBarController()
                    SelectLoginTypeVC.keychain.set(false, forKey: "isFirst")
                    self.view.hideBlockingView()
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       let window = windowScene.windows.first {
                        window.rootViewController = homeTabBarController
                        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
                    }
                }
            } catch {
                self.view.hideBlockingView()
                errorHandler.handleNetworkError(error, in: self)
            }
        }
    }
}
