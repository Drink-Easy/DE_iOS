// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Then
import CoreModule
import SnapKit

/// 페이지네이션 + 빅타이틀
class NoPageTopView: UIView {
    private lazy var title = UILabel().then {
        $0.textColor = AppColor.black
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 24)
        $0.numberOfLines = 0
    }

    init(currentPage: Int, entirePage: Int) {
        super.init(frame: .zero)
        backgroundColor = AppColor.bgGray
        
        self.addComponents()
        self.constraints()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func setTitleLabel(_ text: String) {
        self.title.text = text
    }
    
    private func addComponents() {
        [title].forEach{ self.addSubview($0) }
    }
    
    private func constraints() {
        title.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

