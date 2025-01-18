// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule

public class TermsOfServiceVC: UIViewController, UIDocumentInteractionControllerDelegate {
    
    // MARK: - Properties
    let navigationBarManager = NavigationBarManager()
    
    var agreements: [Bool] = [false, false, false, false]
    private var isAllAgreed: Bool = false
    
    private var agreeItems: [TermsAgreeView] = []
    
    // MARK: - UI Components
    private let subHeaderLabel = UILabel().then {
        $0.text = "사용자의 더 특별한 경험을 위해\n약관 동의가 필요합니다."
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 24)
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private let allTitleLabel = UILabel().then {
        $0.text = "전체 약관 동의"
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 16)
        $0.textColor = AppColor.black
    }
    
    private let dividerView = UIView().then {
        $0.backgroundColor = AppColor.gray30
    }
    
    private let allToggleButton = UIButton(type: .system).then {
        $0.tintColor = AppColor.gray30
        $0.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        $0.addTarget(self, action: #selector(allAgreeButtonTapped), for: .touchUpInside)
    }
    
    private let startButton = CustomButton(
        title: "시작하기",
        titleColor: .white,
        isEnabled: false
    ).then {
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Lifecycle
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.leftBarButtonItem = nil
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 컨트롤러의 루트 뷰 초기화
        let navController = UINavigationController(rootViewController: self)
        navController.modalPresentationStyle = .fullScreen
        
        // 현재 창의 rootViewController 교체
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = navController
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        }
        
        
        setupNavigationBar()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - UI Setup
    private func setupNavigationBar() {
        navigationBarManager.setTitle(to: navigationItem, title: "서비스 약관 동의", textColor: AppColor.black!)
    }
    
    private func setupUI() {
        view.backgroundColor = AppColor.bgGray
        
        [subHeaderLabel, allTitleLabel, allToggleButton, dividerView, startButton].forEach {
            view.addSubview($0)
        }
        
        for index in 0..<3 {
            let title = ["개인정보 수집 및 이용 동의 (필수)", "위치정보 이용약관 (필수)", "서비스 이용약관 (필수)"][index]
            //TODO: 위치정보 약관 추가 필요
            let contents = [Constants.Policy.privacy, "location", Constants.Policy.service][index]
            let agreeView = createAgreeView(title: title, content: contents ,index: index)
            agreeItems.append(agreeView)
            view.addSubview(agreeView)
        }
    }
    
    private func setupConstraints() {
        subHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(32.0))
            make.leading.equalToSuperview().inset(DynamicPadding.dynamicValue(32.0))
        }
        allToggleButton.snp.makeConstraints { make in
            make.top.equalTo(subHeaderLabel.snp.bottom).offset(DynamicPadding.dynamicValue(50.0))
            make.leading.equalToSuperview().inset(DynamicPadding.dynamicValue(32.0))
            make.width.height.equalTo(24)
        }
        
        allTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(allToggleButton)
            make.leading.equalTo(allToggleButton.snp.trailing).offset(10)
        }
        
        dividerView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(32.0))
            make.top.equalTo(allTitleLabel.snp.bottom).offset(DynamicPadding.dynamicValue(20.0))
        }
        
        for (index, view) in agreeItems.enumerated() {
            view.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                
                if index == 0 {
                    make.top.equalTo(dividerView.snp.bottom).offset(DynamicPadding.dynamicValue(20.0)) // 첫 번째 뷰의 제약 조건
                } else {
                    make.top.equalTo(agreeItems[index - 1].snp.bottom).offset(DynamicPadding.dynamicValue(10.0)) // 이전 뷰의 아래쪽에 위치
                }
                
                make.height.equalTo(DynamicPadding.dynamicValue(32.0))
            }
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(32.0))
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-DynamicPadding.dynamicValue(40.0))
        }
    }
    
    
    // MARK: - Factory Method
    private func createAgreeView(title: String, content: String, index: Int) -> TermsAgreeView {
        return TermsAgreeView().then { agreeView in
            agreeView.configure(
                title: title,
                content: content,
                isChecked: agreements[index],
                parentViewController: self
            )
            
            agreeView.onStateChange = { [weak self] isChecked in
                guard let self = self else { return }
                self.agreements[index] = isChecked
                self.updateStartButtonState()
            }
        }
    }
    
    // MARK: - Actions
    @objc private func allAgreeButtonTapped() {
        isAllAgreed.toggle()
        agreements = Array(repeating: isAllAgreed, count: agreements.count)
        allToggleButton.tintColor = isAllAgreed ? AppColor.purple100 : AppColor.gray30
        agreeItems.forEach { $0.setChecked(isChecked: isAllAgreed) }
        updateStartButtonState()
    }
    
    private func updateStartButtonState() {
        let allRequiredAgreed = agreements.prefix(3).allSatisfy { $0 }
        isAllAgreed = allRequiredAgreed
        allToggleButton.tintColor = isAllAgreed ? AppColor.purple100 : AppColor.gray30
        startButton.isEnabled = allRequiredAgreed
        startButton.isEnabled(isEnabled: allRequiredAgreed)
    }
    
    @objc private func startButtonTapped() {
        let vc = WelcomeVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
