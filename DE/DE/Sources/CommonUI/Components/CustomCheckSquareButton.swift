// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import UIKit

public class CustomCheckSquareButton: UIButton {
    public init(title: String) {
        super.init(frame: .zero)
        self.setImage(UIImage(systemName: "checkmark.square.fill")?.withTintColor(AppColor.gray30, renderingMode: .alwaysOriginal), for: .normal)
        self.setImage(UIImage(systemName: "checkmark.square.fill")?.withTintColor(AppColor.purple100, renderingMode: .alwaysOriginal), for: .selected)
        self.setTitle(title, for: .normal)
        self.setTitleColor(AppColor.black , for: .normal)
        self.titleLabel?.font = UIFont.ptdMediumFont(ofSize: 14)
        
        if let imageView = self.imageView, let titleLabel = self.titleLabel {
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(22)
            }
            titleLabel.snp.makeConstraints { make in
                make.centerY.equalTo(imageView)
                make.leading.equalTo(imageView.snp.trailing)
            }
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
