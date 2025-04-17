// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Then
import CoreModule
import DesignSystem
import SnapKit

// 기기대응 완료
/// 날짜 있는 쪽에만 쓰는  빅타이틀
class NoCountDateTopView: UIView {
    
//    public lazy var title = UILabel().then {
//        $0.textColor = AppColor.purple100
//        $0.font = UIFont.ptdSemiBoldFont(ofSize: 24)
//        $0.numberOfLines = 0
//    }
//    
//    public lazy var desp = UILabel().then {
//        $0.textColor = AppColor.black
//        $0.font = UIFont.ptdSemiBoldFont(ofSize: 24)
//        $0.numberOfLines = 1
//    }
    
    public lazy var titleLabel = UILabel().then {
        $0.numberOfLines = 0
    }

    init() {
        super.init(frame: .zero)
        backgroundColor = AppColor.background
        
        self.addComponents()
        self.constraints()
    }

    public func setTitleLabel(
        title: String,
        titleStyle: TextStyle,
        titleColor: UIColor,
        description: String,
        descriptionStyle: TextStyle,
        descriptionColor: UIColor,
        lineSpacing: CGFloat = 2
    ) {
        let fullText = "\(title)\n\(description)"
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.minimumLineHeight = titleStyle.fontSize * titleStyle.lineHeightMultiple
        paragraphStyle.maximumLineHeight = titleStyle.fontSize * titleStyle.lineHeightMultiple

        let attributedString = NSMutableAttributedString(string: fullText)

        let titleRange = (fullText as NSString).range(of: title)
        attributedString.addAttributes([
            .font: titleStyle.font,
            .foregroundColor: titleColor,
            .paragraphStyle: paragraphStyle,
            .kern: titleStyle.fontSize * (titleStyle.letterSpacingPercent / 100)
        ], range: titleRange)
        
        let descriptionRange = (fullText as NSString).range(of: description)
        attributedString.addAttributes([
            .font: descriptionStyle.font,
            .foregroundColor: descriptionColor,
            .paragraphStyle: paragraphStyle,
            .kern: descriptionStyle.fontSize * (descriptionStyle.letterSpacingPercent / 100)
        ], range: descriptionRange)

        titleLabel.attributedText = attributedString
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addComponents() {
        [titleLabel].forEach{ self.addSubview($0) }
    }
    
    private func constraints() {
        titleLabel.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
        
//        title.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.leading.trailing.equalToSuperview()
//        }
//        
//        desp.snp.makeConstraints {
//            $0.top.equalTo(title.snp.bottom).offset(1)
//            $0.leading.trailing.equalToSuperview()
//            $0.bottom.equalToSuperview()
//        }
    }
}

