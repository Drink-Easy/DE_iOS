//
//  SearchBar.swift
//  Drink-EG
//
//  Created by 이현주 on 12/17/24.
//

import UIKit

class SearchBar: UITextField {
    
    var placeholderText: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSearchBar()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        // 기본 플레이스홀더
        self.attributedPlaceholder = NSAttributedString(
            string: "검색어 입력",
            attributes: [
                .foregroundColor: UIColor(hex: "#C2C2C2") ?? .gray,
                .font: UIFont.ptdRegularFont(ofSize: 14)
            ]
        )
        
        let icon = UIImage(named: "searchBarIcon")
        let imageView = UIImageView(image: icon)
        imageView.tintColor = UIColor(hex: "#919191") ?? .gray
        imageView.contentMode = .scaleAspectFit
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        imageView.frame = CGRect(x: 4, y: 3, width: 18.5, height: 18.5)
        containerView.addSubview(imageView)
        
        self.leftView = containerView
        self.leftViewMode = .always
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = UIColor(hex: "#FCFCFC")
        self.contentHorizontalAlignment = .left
    }
    
    // 플레이스홀더 업데이트 func
    private func updatePlaceholder() {
        if let text = placeholderText {
            self.attributedPlaceholder = NSAttributedString(
                string: text,
                attributes: [
                    .foregroundColor: UIColor(hex: "#C2C2C2") ?? .gray,
                    .font: UIFont.systemFont(ofSize: 13.5, weight: .regular)
                ]
            )
        }
    }
}
