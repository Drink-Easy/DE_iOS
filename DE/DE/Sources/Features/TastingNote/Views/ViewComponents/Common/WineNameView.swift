// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule

class WineNameView: UIView {
    public lazy var header = UILabel().then {
        $0.textColor = AppColor.black
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 24)
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setTitleLabel(_ text: String) {
        self.header.text = text
    }
    
    private func setConstraints() {
        addSubview(header)
        header.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
    }
}
