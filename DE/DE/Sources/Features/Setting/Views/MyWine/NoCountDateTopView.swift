// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Then
import CoreModule
import DesignSystem
import SnapKit

// 기기대응 완료
/// 날짜 있는 쪽에만 쓰는  빅타이틀
class NoCountDateTopView: UIView {
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
        lineSpacing: CGFloat = 0
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
        addSubview(titleLabel)
    }
    
    private func constraints() {
        titleLabel.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}

