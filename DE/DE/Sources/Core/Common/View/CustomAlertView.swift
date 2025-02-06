// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

class CustomAlertView: UIView {
    var onDismiss: (() -> Void)?
    
    // MARK: - UI Elements
    private let containerView = UIView().then { view in
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then { label in
        label.textAlignment = .center
        label.font = UIFont.ptdSemiBoldFont(ofSize: 18)
        label.textColor = AppColor.DGblack
        label.numberOfLines = 0
    }
    
    private let messageTextView = UITextView().then { textView in
        textView.font = UIFont.ptdRegularFont(ofSize: 16)
        textView.textAlignment = .center
        textView.textColor = AppColor.gray100
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = true
        textView.textContainerInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        textView.backgroundColor = .clear
    }
    
    private let confirmButton = UIButton().then { button in
        button.setTitle("확인", for: .normal)
        button.setTitleColor(AppColor.purple100, for: .normal)
        button.titleLabel?.font = UIFont.ptdSemiBoldFont(ofSize: 18)
    }
    
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        addSubview(containerView)
        containerView.frame = CGRect(x: 50, y: 100, width: 300, height: 200)
        addGradientBackground(to: containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageTextView)
        containerView.addSubview(confirmButton)
        
        setupConstraints()
        
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
    }
    
    func addGradientBackground(to view: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            AppColor.white?.cgColor as Any, // 100% 불투명
            AppColor.purple30?.withAlphaComponent(0.2).cgColor as Any // 20% 투명도
        ]
        gradientLayer.locations = [0.0, 1.0] // 시작(0%) → 끝(100%)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0) // 위쪽 중앙
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0) // 아래쪽 중앙
        gradientLayer.frame = view.bounds
        gradientLayer.cornerRadius = view.layer.cornerRadius
        
        view.layer.insertSublayer(gradientLayer, at: 0) // ✅ 최하단에 추가
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // containerView 외부는 터치 이벤트를 무시
        if !containerView.frame.contains(point) {
            return false
        }
        return true
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(300)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView).offset(24)
            make.leading.equalTo(containerView).offset(16)
            make.trailing.equalTo(containerView).offset(-16)
        }
        
        messageTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalTo(containerView).offset(16)
            make.trailing.equalTo(containerView).offset(-16)
            make.height.lessThanOrEqualTo(160) // 최대 높이 제한
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(messageTextView.snp.bottom).offset(24)
            make.bottom.equalTo(containerView).offset(-16)
            make.centerX.equalTo(containerView)
        }
    }
    
    // MARK: - Public Configuration Method
    func configure(title: String, message: String) {
        titleLabel.text = title
        messageTextView.text = message

        // 강제 레이아웃 업데이트
        layoutIfNeeded()
    }
    
    // MARK: - Actions
    @objc private func didTapConfirmButton() {
        // 팝업 닫기
        self.removeFromSuperview()
        onDismiss?()
    }
}
