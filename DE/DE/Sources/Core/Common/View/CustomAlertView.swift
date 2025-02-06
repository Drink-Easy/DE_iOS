// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

public class CustomAlertView: UIView {
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
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        backgroundColor = AppColor.black?.withAlphaComponent(0.3)
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(messageTextView)
        containerView.addSubview(confirmButton)
        
        confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
    }
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
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
            make.top.equalToSuperview().offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        messageTextView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.lessThanOrEqualTo(160) // 최대 높이 제한
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(messageTextView.snp.bottom).offset(24)
            make.bottom.equalToSuperview().offset(-16)
            make.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Public Configuration Method
    public func configure(title: String, message: String) {
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
