// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule

class SelectLoginTypeView: UIView {
    
    // MARK: - UI Components
    let imageView = UIImageView().then {
        $0.image = UIImage(named: "logo")
    }
    
    let kakaoButton = UIButton().then {
        $0.backgroundColor = UIColor(hex: "#FEE500")
        $0.setTitle("카카오로 시작하기", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        $0.setTitleColor(UIColor(hex: "#191919"), for: .normal)
        $0.layer.cornerRadius = 15
        
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
    }
    
    let appleButton = UIButton().then {
        $0.backgroundColor = UIColor(hex: "#000000")
        $0.setTitle("애플로 시작하기", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        $0.setTitleColor(UIColor(hex: "#FFFFFF"), for: .normal)
        $0.layer.cornerRadius = 15
        
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
    }
    
    let loginButton = CustomButton(
        title: "로그인",
        titleColor: .white,
        backgroundColor: AppColor.purple100!
    )
    
    let joinStackView = JoinStackView()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        [imageView, kakaoButton, appleButton, loginButton, joinStackView].forEach {
            addSubview($0)
        }
        
        if let image = UIImage(named: "kakao")?.withRenderingMode(.alwaysOriginal) {
            let resizedImage = resizeImage(image: image, targetHeight: 24)
            kakaoButton.setImage(resizedImage, for: .normal)
        }
        if let image = UIImage(named: "apple")?.withRenderingMode(.alwaysOriginal) {
            let resizedImage = resizeImage(image: image, targetHeight: 24)
            appleButton.setImage(resizedImage, for: .normal)
        }
        
    }
    
    func resizeImage(image: UIImage, targetHeight: CGFloat) -> UIImage {
        let aspectRatio = image.size.width / image.size.height
        let targetSize = CGSize(width: targetHeight * aspectRatio, height: targetHeight)
        
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(Constants.superViewHeight * 0.3)
            make.width.lessThanOrEqualTo(Constants.superViewWidth * 0.6)
        }
        kakaoButton.snp.makeConstraints { make in
            make.top.equalTo(Constants.superViewHeight * 0.6)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
            make.height.equalTo(60)
        }
        appleButton.snp.makeConstraints { make in
            make.top.equalTo(kakaoButton.snp.bottom).offset(10)
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
        }
        loginButton.snp.makeConstraints { make in
            make.top.equalTo(appleButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(Constants.padding)
        }
        joinStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
        }
    }
}
