// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Then

class PageControlNumberView: UIView {
    
    var currentPage: Int = 1 {
        didSet {
            updatePageLabel()
        }
    }

    var totalPages: Int = 0 {
        didSet {
            updatePageLabel()
        }
    }
    
    private lazy var pageNumber = UILabel().then {
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = AppColor.gray100?.withAlphaComponent(0.7)
        self.layer.cornerRadius = DynamicPadding.dynamicValue(15)
        self.layer.masksToBounds = true
        self.addComponents()
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addComponents() {
        [pageNumber].forEach{ self.addSubview($0) }
    }
    
    private func constraints() {
        pageNumber.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    private func updatePageLabel() {
        let text = "\(currentPage) / \(totalPages)"
        let attributedString = NSMutableAttributedString(string: text)

        // 현재 페이지를 white로 설정
        let currentPageRange = (text as NSString).range(of: "\(currentPage)")
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: currentPageRange)

        // 나머지를 white 50% 로 설정
        let totalPagesRange = (text as NSString).range(of: "/ \(totalPages)")
        attributedString.addAttribute(.foregroundColor, value: UIColor.white.withAlphaComponent(0.5), range: totalPagesRange)

        // 폰트 설정 (선택 사항)
        attributedString.addAttribute(.font, value: UIFont.ptdMediumFont(ofSize: 14), range: NSRange(location: 0, length: text.count))

        pageNumber.attributedText = attributedString
    }
}
