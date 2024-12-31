// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

public class CustomBlurButton: UIButton {
    private let blurEffectView = UIVisualEffectView().then {
        $0.effect = UIBlurEffect(style: .light)
        $0.isUserInteractionEnabled = false // 터치 이벤트 전달 가능하도록 설정
    }
    
    public init(
        title: String = "",
        titleColor: UIColor = .black,
        blurStyle: UIBlurEffect.Style = .light
    ) {
        super.init(frame: .zero)
        
        addSubview(blurEffectView)
        blurEffectView.effect = UIBlurEffect(style: blurStyle)
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.then {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(titleColor, for: .normal)
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            $0.layer.cornerRadius = 15
            $0.clipsToBounds = true
        }.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(
        title: String,
        titleColor: UIColor,
        blurStyle: UIBlurEffect.Style
    ) {
        self.then {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(titleColor, for: .normal)
            self.blurEffectView.effect = UIBlurEffect(style: blurStyle)
        }
    }
}
