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
        $0.layer.cornerRadius = 16
        $0.layer.masksToBounds = true
    }
    
    public lazy var nickNameLabel: UILabel = createLabel(title: "닉네임", isTitle: true)
    public lazy var cityLabel: UILabel = createLabel(title: "내 동네", isTitle: true)
    public lazy var emailLabel: UILabel = createLabel(title: "이메일", isTitle: true)
    public lazy var loginTypeLabel: UILabel = createLabel(title: "연동상태", isTitle: true)
    public lazy var adultLabel: UILabel = createLabel(title: "성인인증", isTitle: true)
    
    public lazy var nickNameVal: UILabel = createLabel(title: "더미", isTitle: false)
    public lazy var cityVal: UILabel = createLabel(title: "더미", isTitle: false)
    public lazy var emailVal: UILabel = createLabel(title: "더미", isTitle: false)
    public lazy var loginTypeVal: UILabel = createLabel(title: "더미", isTitle: false)
    public lazy var adultVal: UILabel = createLabel(title: "더미", isTitle: false)
    
    public lazy var line1: UIView = createline()
    public lazy var line2: UIView = createline()
    public lazy var line3: UIView = createline()
    public lazy var line4: UIView = createline()
    
    public lazy var stack1: UIStackView = UIStackView(arrangedSubviews: [nickNameLabel, nickNameVal]).then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .fill
        $0.spacing = 8
    }
    
    public lazy var stack2: UIStackView = UIStackView(arrangedSubviews: [cityLabel, cityVal]).then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .fill
        $0.spacing = 8
    }
    
    public lazy var stack3: UIStackView = UIStackView(arrangedSubviews: [emailLabel, emailVal]).then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .fill
        $0.spacing = 8
    }
    
    public lazy var stack4: UIStackView = UIStackView(arrangedSubviews: [loginTypeLabel, loginTypeVal]).then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .fill
        $0.spacing = 8
    }
    
    public lazy var stack5: UIStackView = UIStackView(arrangedSubviews: [adultLabel, adultVal]).then {
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
        [stack1, line1, stack2, line2, stack3, line3, stack4, line4, stack5].forEach {
            backView.addSubview($0)
        }
        [titleLabel, backView].forEach {
            addSubview($0)
        }
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
        stack1.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalTo(40)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        line1.snp.makeConstraints { make in
            make.top.equalTo(stack1.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        stack2.snp.makeConstraints { make in
            make.top.equalTo(line1.snp.bottom)
            make.height.equalTo(40)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        line2.snp.makeConstraints { make in
            make.top.equalTo(stack2.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        stack3.snp.makeConstraints { make in
            make.top.equalTo(line2.snp.bottom)
            make.height.equalTo(40)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        line3.snp.makeConstraints { make in
            make.top.equalTo(stack3.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        stack4.snp.makeConstraints { make in
            make.top.equalTo(line3.snp.bottom)
            make.height.equalTo(40)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        line4.snp.makeConstraints { make in
            make.top.equalTo(stack4.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(1)
        }
        
        stack5.snp.makeConstraints { make in
            make.top.equalTo(line4.snp.bottom)
            make.height.equalTo(40)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        backView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(4)
            make.height.greaterThanOrEqualTo(204)
        }
        
    }
}
