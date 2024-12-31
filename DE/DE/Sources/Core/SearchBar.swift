//
//  SearchBar.swift
//  Drink-EG
//
//  Created by 이현주 on 12/17/24.
//

import UIKit
import CoreModule

public class SearchBar: UITextField {
    
    var placeholderText: String?
    private let imageView = UIImageView()
    
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
                .foregroundColor: AppColor.gray70 ?? .gray,
                .font: UIFont.ptdRegularFont(ofSize: 14)
            ]
        )
        self.textColor = AppColor.gray100
        self.tintColor = AppColor.purple100
        //self.font = UIFont.ptdSemiBoldFont(ofSize: 14)
        
        let icon = UIImage(named: "searchBarIcon")?.withRenderingMode(.alwaysTemplate)
        imageView.image = icon
        imageView.tintColor = AppColor.gray70 ?? .gray
        imageView.contentMode = .scaleAspectFit
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 24))
        imageView.frame = CGRect(x: 7.6, y: 0, width: 24, height: 24)
        containerView.addSubview(imageView)
        
        self.leftView = containerView
        self.leftViewMode = .always
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        self.backgroundColor = AppColor.gray10
        self.contentHorizontalAlignment = .left
        self.clearButtonMode = .whileEditing
    }
    
    public override func becomeFirstResponder() -> Bool {
        let didBecomeFirstResponder = super.becomeFirstResponder()
        if didBecomeFirstResponder {
            self.backgroundColor = AppColor.bgGray
            self.layer.borderWidth = 1
            self.layer.borderColor = AppColor.purple100?.cgColor
            self.imageView.tintColor = AppColor.purple100
        }
        return didBecomeFirstResponder
    }
    
    public override func resignFirstResponder() -> Bool {
        let didResignFirstResponder = super.resignFirstResponder()
        if didResignFirstResponder {
            self.backgroundColor = AppColor.gray10
            self.layer.borderWidth = 0
            
            // 아이콘 색상 원래대로
            imageView.tintColor = AppColor.gray70
        }
        return didResignFirstResponder
    }
}
