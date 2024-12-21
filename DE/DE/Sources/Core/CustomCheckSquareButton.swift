// Copyright © 2024 DRINKIG. All rights reserved

import Foundation
import UIKit

public class CustomCheckSquareButton: UIButton {
    public init(title: String) {
        super.init(frame: .zero)
        self.setImage(UIImage(systemName: "checkmark.square.fill")?.withTintColor(AppColor.gray80 ?? .blue, renderingMode: .alwaysOriginal), for: .selected)
        self.setImage(UIImage(systemName: "checkmark.square.fill")?.withTintColor(AppColor.purple100 ?? .gray, renderingMode: .alwaysOriginal), for: .normal)
        self.setTitle(title, for: .normal)
        self.setTitleColor(AppColor.black ?? .gray , for: .normal)
        self.titleLabel?.font = UIFont.ptdRegularFont(ofSize: 13)
        
        self.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        if let imageView = self.imageView, let titleLabel = self.titleLabel {
            imageView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.width.equalTo(20)
                make.height.equalTo(20)
            }
            titleLabel.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(10)
                make.centerY.equalTo(imageView)
            }
        }
        self.contentHorizontalAlignment = .left
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
