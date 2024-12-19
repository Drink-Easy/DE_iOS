//
//  WineImageStackView.swift
//  Drink-EG
//
//  Created by 이수현 on 9/28/24.
//

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
            imageView.contentMode = .scaleAspectFit
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
            
            self.addArrangedSubview(subStackView)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
