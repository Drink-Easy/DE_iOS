// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

public class SearchBar: UITextField {
    
    public var placeholderText: String?
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
            string: "와인 이름을 검색하세요 (한글/영문)",
            attributes: [
                .foregroundColor: AppColor.gray70,
                .font: UIFont.pretendard(.regular, size: 14)
            ]
        )
        self.textColor = AppColor.gray100
        self.tintColor = AppColor.purple100
        //self.font = UIFont.ptdSemiBoldFont(ofSize: 14)
        self.autocapitalizationType = .none //자동 대문자
        self.spellCheckingType = .no //맞춤법 검사
        self.autocorrectionType = .no //자동완성
        
        let icon = UIImage(named: "searchBarIcon")?.withRenderingMode(.alwaysTemplate)
        imageView.image = icon
        imageView.tintColor = AppColor.gray70
        imageView.contentMode = .scaleAspectFit
        
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: DynamicPadding.dynamicValue(47), height: DynamicPadding.dynamicValue(24)))
        imageView.frame = CGRect(x: DynamicPadding.dynamicValue(14.6), y: 0, width: DynamicPadding.dynamicValue(24), height: DynamicPadding.dynamicValue(24))
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
            self.backgroundColor = AppColor.background
            self.layer.borderWidth = 1
            self.layer.borderColor = AppColor.purple100.cgColor
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
