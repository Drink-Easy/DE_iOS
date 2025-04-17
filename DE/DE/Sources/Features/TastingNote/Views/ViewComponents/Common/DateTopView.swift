// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Then
import CoreModule
import DesignSystem
import SnapKit

/// 날짜 있는 쪽에만 쓰는 페이지네이션 + 빅타이틀
class DateTopView: UIView {
    
    var currentPage: Int?
    var entirePage: Int?
    
    private lazy var page = UILabel().then {
        $0.font = UIFont.pretendard(.medium, size: 16)
    }
    
    public lazy var titleLabel = UILabel().then {
        $0.numberOfLines = 0
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

    init(currentPage: Int, entirePage: Int) {
        super.init(frame: .zero)
        backgroundColor = AppColor.background
        self.currentPage = currentPage
        self.entirePage = entirePage
        
        self.addComponents()
        self.constraints()
        updatePageLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func updatePageLabel() {
        guard let currentPage = currentPage, let entirePage = entirePage else { return }
        configureFractionLabel(page, currentPage: "\(currentPage)", entirePage: "\(entirePage)")
    }
    
    public func configureFractionLabel(_ label: UILabel, currentPage: String, entirePage: String) {
        let fullText = "\(currentPage)/\(entirePage)"
        let attributedText = NSMutableAttributedString(string: fullText)
        
        let slashIndex = (currentPage as NSString).length
        attributedText.addAttribute(.foregroundColor, value: AppColor.purple70, range: NSRange(location: 0, length: slashIndex))
        attributedText.addAttribute(.foregroundColor, value: AppColor.gray70, range: NSRange(location: slashIndex, length: fullText.count - slashIndex))
        
        label.attributedText = attributedText
    }
    
    private func addComponents() {
        [page, titleLabel].forEach{ self.addSubview($0) }
    }
    
    private func constraints() {
        page.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(page.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
    }
}

