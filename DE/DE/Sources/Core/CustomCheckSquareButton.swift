// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import UIKit

public class CustomCheckSquareButton: UIButton {
    public init(title: String) {
        super.init(frame: .zero)
        self.setImage(UIImage(systemName: "checkmark.square.fill")?.withTintColor(AppColor.gray80 ?? .gray, renderingMode: .alwaysOriginal), for: .normal)
        self.setImage(UIImage(systemName: "checkmark.square.fill")?.withTintColor(AppColor.purple100 ?? .blue, renderingMode: .alwaysOriginal), for: .selected)
        self.setTitle(title, for: .normal)
        self.setTitleColor(AppColor.black ?? .gray , for: .normal)
        self.titleLabel?.font = UIFont.ptdMediumFont(ofSize: 14)
        
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        if let imageView = self.imageView, let titleLabel = self.titleLabel {
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(22)
            }
            titleLabel.snp.makeConstraints { make in
                make.leading.equalTo(imageView.snp.trailing).offset(15)
                make.centerY.equalTo(imageView)
            }
        }
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
