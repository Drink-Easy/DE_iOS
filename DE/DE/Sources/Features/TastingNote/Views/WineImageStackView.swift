// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit

class WineImageStackView: UIStackView {
    
    init() {
        super.init(frame: .zero)
        self.axis = .horizontal
        self.alignment = .center
        self.spacing = 10
        self.distribution = .fillEqually
        
        for (imageName, imageLabel) in ImageStackView().images {
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 10
            
            let label = UILabel()
            label.text = imageLabel
            label.textColor = .black
            label.font = UIFont(name: "Pretendard-Regular", size: 14)
            
            let subStackView = UIStackView()
            subStackView.axis = .vertical
            subStackView.alignment = .center
            subStackView.spacing = 8
            subStackView.addArrangedSubview(imageView)
            subStackView.addArrangedSubview(label)
            
            imageView.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(imageView.snp.width)
            }
            
            label.snp.makeConstraints { make in
                make.top.equalTo(imageView.snp.bottom).offset(8)
                // make.leading.equalTo(imageView.snp.leading).offset(13)
                make.centerX.equalTo(imageView.snp.centerX)
            }
            
            self.addArrangedSubview(subStackView)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
