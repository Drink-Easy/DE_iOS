// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule

public class WelcomeVC: UIViewController {
    
    // MARK: - UI Components
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "logo")
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "드링키지에 온 걸 환영해요."
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 28)
        $0.textColor = AppColor.black
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let subtitleLabel = UILabel().then {
        let text = "어플을 더욱 알차게 사용하실 수 있게\n저희에게 몇 가지 정보를 알려주세요!"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4  // ✅ 행간 설정
        paragraphStyle.alignment = .center  // ✅ 가운데 정렬

        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.ptdMediumFont(ofSize: 18),
            .foregroundColor: AppColor.gray70!,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        
        $0.attributedText = attributedText
        $0.numberOfLines = 0
    }
    
    private let startButton = CustomButton(
        title: "시작하기",
        titleColor: .white,
        isEnabled: true
    )
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = AppColor.bgGray
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(startButton)
        
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(Constants.superViewHeight * 0.3)
            make.width.height.equalTo(DynamicPadding.dynamicValue(100.0))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(DynamicPadding.dynamicValue(48.0))
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24.0))
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(DynamicPadding.dynamicValue(32.0))
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24.0))
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24.0))
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-DynamicPadding.dynamicValue(40.0))
        }
    }
    
    // MARK: - Actions
    @objc private func startButtonTapped() {
        let getProfileController = GetProfileVC()
        navigationController?.pushViewController(getProfileController, animated: true)
    }
}
