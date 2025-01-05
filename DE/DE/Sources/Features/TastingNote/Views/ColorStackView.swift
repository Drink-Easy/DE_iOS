// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import CoreModule

class ColorStackView: UIStackView {

    weak var delegate: ColorStackViewDelegate?
    var prevButton: UIButton? = nil
    private let checkMark = UIImage(named: "checkMark")
    
    init(colors: [[UIColor]]) {
        super.init(frame: .zero)
        setupVerticalStackView(colors: colors)
    }

    
    private func setupVerticalStackView(colors: [[UIColor]]) {
        // 수직 스택뷰 생성
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.spacing = 12
        verticalStackView.distribution = .fillEqually
        
        // 각 행에 대해 수평 스택뷰 추가
        for rowColors in colors {
            let horizontalStackView = createHorizontalStackView(colors: rowColors)
            verticalStackView.addArrangedSubview(horizontalStackView)
        }
        
        // 수직 스택뷰 추가 및 레이아웃 설정
        self.addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func createHorizontalStackView(colors: [UIColor]) -> UIStackView {
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .center
        horizontalStackView.spacing = 8
        horizontalStackView.distribution = .fillEqually
        
        // 색상 버튼 추가
        for color in colors {
            let colorButton = UIButton()
            colorButton.backgroundColor = color
            colorButton.layer.cornerRadius = 10
            colorButton.layer.masksToBounds = true
            
            let checkImageView = UIImageView(image: checkMark)
            checkImageView.contentMode = .scaleAspectFit
            checkImageView.isHidden = true
            checkImageView.tag = 1
            colorButton.addSubview(checkImageView)
            
            horizontalStackView.addArrangedSubview(colorButton)
            
            checkImageView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(28) // 체크마크 크기
            }
            
            colorButton.snp.makeConstraints { make in
                make.width.height.equalTo(50) // 버튼 크기 설정
            }
            
            colorButton.addTarget(self, action: #selector(didTapColorView), for: .touchUpInside)
        }
        return horizontalStackView
    }
    
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapColorView(sender: UIButton) {
        
        if prevButton == sender {
            sender.layer.borderWidth = 0
            if let checkmark = sender.viewWithTag(1) as? UIImageView {
                checkmark.isHidden = true
            }
            prevButton = nil
            delegate?.colorStackView(self, didSelectColor: nil)
            return
        }
        
        if let prev = prevButton, let prevCheckmark = prev.viewWithTag(1) as? UIImageView {
            prev.layer.borderWidth = 0
            prevCheckmark.isHidden = true
        }
        
        sender.layer.borderWidth = 1.5
        sender.layer.borderColor = UIColor(hex: "#F8F8FA")?.cgColor
        if let checkmark = sender.viewWithTag(1) as? UIImageView {
            checkmark.isHidden = false
        }
        
        prevButton = sender
        
        if let color = sender.backgroundColor {
            delegate?.colorStackView(self, didSelectColor: color)
        }
    }
    
}

protocol ColorStackViewDelegate: AnyObject {
    func colorStackView(_ stackView: ColorStackView, didSelectColor color: UIColor?)
}
