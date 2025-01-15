// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

public class SimpleListView: UIView {
    
    public lazy var titleLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .ptdSemiBoldFont(ofSize: 18)
    }
    
    public lazy var backView = UIView().then {
        $0.backgroundColor = .systemBackground
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
    }
    
    public let nickNameLabel = createLabel(title: "닉네임", isTitle: true)
    public let cityLabel = createLabel(title: "내 동네", isTitle: true)
    public let emailLabel = createLabel(title: "이메일", isTitle: true)
    public let loginTypeLabel = createLabel(title: "연동상태", isTitle: true)
    public let adultLabel = createLabel(title: "성인인증", isTitle: true)
    
    public lazy var nickNameVal = createLabel(title: "더미", isTitle: false)
    public lazy var cityVal = createLabel(title: "더미", isTitle: false)
    public lazy var emailVal = createLabel(title: "더미", isTitle: false)
    public lazy var loginTypeVal = createLabel(title: "더미", isTitle: false)
    public lazy var adultVal = createLabel(title: "더미", isTitle: false)
    
    public var line1 = createline()
    public var line2 = createline()
    public var line3 = createline()
    public var line4 = createline()
    
    public let stack1 = UIStackView(arrangedSubviews: [nickNameLabel, nickNameVal]).then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .fill
        $0.spacing = 8
    }
    
    public let stack2 = UIStackView(arrangedSubviews: [cityLabel, cityVal]).then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .fill
        $0.spacing = 8
    }
    
    public let stack3 = UIStackView(arrangedSubviews: [emailLabel, emailVal]).then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .fill
        $0.spacing = 8
    }
    
    public func createLabel(title: String, isTitle: Bool) -> UILabel {
        return UILabel().then {
            $0.font = .ptdRegularFont(ofSize: 14)
            $0.textColor = isTitle ? .black : AppColor.gray50 ?? .gray
            $0.textAlignment = isTitle ? .left : .right
            $0.text = title
            $0.numberOfLines = 0
        }
    }
    
    public func createline() -> UIView {
        return UIView().then {
            $0.backgroundColor = AppColor.gray30 ?? .gray
        }
    }
    
    public func setTitle(_ title: String) {
        self.titleLabel.text = title
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backView.addSubview(stack1)
        backView.addSubview(line1)
        [titleLabel, backView].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(4)
        }
        
        stack1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        line1.snp.makeConstraints { make in
            make.top.equalTo(stack1.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(4)
            make.height.equalTo(1)
        }
        
        stack2.snp.makeConstraints { make in
            make.top.equalTo(line1.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        
        line2.snp.makeConstraints { make in
            make.top.equalTo(stack1.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(4)
            make.height.equalTo(1)
        }
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(4)
            make.height.greaterThanOrEqualTo(200)
        }
        
    }
}
