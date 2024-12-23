// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import UIKit
import SnapKit

public class CustomBlurButton: UIButton {
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.isUserInteractionEnabled = false // 터치 이벤트 전달 가능하도록 설정
        return view
    }()
    public init(
        title: String = "",
        titleColor: UIColor = .black,
        blurStyle: UIBlurEffect.Style = .light
    ) {
        super.init(frame: .zero)
        
        blurEffectView.effect = UIBlurEffect(style: blurStyle)
        
        addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        self.snp.makeConstraints { make in
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
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.blurEffectView.effect = UIBlurEffect(style: blurStyle)
    }
}
