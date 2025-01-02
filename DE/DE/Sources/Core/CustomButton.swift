// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import UIKit
import SnapKit

open class CustomButton: UIButton {
    public init(
        title: String = "",
        titleColor: UIColor = .black,
        isEnabled: Bool = true
    ) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = isEnabled ? AppColor.purple100 : AppColor.gray30
        
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        self.layer.cornerRadius = 15
        
        self.snp.makeConstraints { make in
            make.height.equalTo(60)
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(title: String, titleColor: UIColor, isEnabled: Bool) {
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = isEnabled ? AppColor.purple100 : AppColor.gray30
    }
    
    public func isEnabled(isEnabled: Bool){
        self.backgroundColor = isEnabled ? AppColor.purple100 : AppColor.gray30
    }
}
