//
//  ColorStackView.swift
//  Drink-EG
//
//  Created by 이수현 on 11/11/24.
//

import UIKit
import SnapKit

class ColorStackView: UIStackView {

    var prevButton: UIButton? = nil
    
    init() {
        super.init(frame: .zero)
        self.axis = .horizontal
        self.alignment = .center
        self.spacing = 8
        self.distribution = .fillEqually
        
        let colors = [UIColor(hex: "#FFFBD8"), UIColor(hex: "#FDEFA4"), UIColor(hex: "#FEB6B6"), UIColor(hex: "#BA2121"), UIColor(hex: "#892222"), UIColor(hex: "#521515")]
        
        for color in colors {
            let colorView = UIButton()
            colorView.backgroundColor = color
            colorView.layer.cornerRadius = 10
            self.addArrangedSubview(colorView)
            
            colorView.snp.makeConstraints { make in
                make.width.height.equalTo(40)
            }
            colorView.addTarget(self, action: #selector(didTapColorView), for: .touchUpInside)
        }
    }
    
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapColorView(sender: UIButton) {
        
        if (prevButton != nil) {
            prevButton?.layer.borderColor = UIColor.clear.cgColor
        }
        
        sender.layer.borderWidth = 2
        sender.layer.borderColor = UIColor(hex: "B06FCD")?.cgColor
        
        prevButton = sender
       
    }
    
}
