// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Then
import CoreModule
import DesignSystem
import SnapKit

/// 페이지네이션 + 빅타이틀
public class TopView: UIView {
    
    private var currentPage: Int
    private var entirePage: Int
    
    private lazy var pageLabel = UILabel().then {
        $0.font = UIFont.pretendard(.medium, size: 16)
    }
    
    public lazy var titleLabel = UILabel().then {
        $0.numberOfLines = 0
    }

    // MARK: - Init
    public init(currentPage: Int, entirePage: Int) {
        self.currentPage = currentPage
        self.entirePage = entirePage
        super.init(frame: .zero)
        backgroundColor = AppColor.background
        setupUI()
        setupConstraints()
        updatePageLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupUI() {
        [pageLabel, titleLabel].forEach { addSubview($0) }
    }

    private func setupConstraints() {
        pageLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(pageLabel.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    // MARK: - Public Methods

    public func setTitleLabel(
        title: String,
        titleStyle: TextStyle = AppTextStyle.KR.head,
        titleColor: UIColor = AppColor.black,
        description: String? = nil,
        descriptionStyle: TextStyle? = nil,
        descriptionColor: UIColor? = nil,
        lineSpacing: CGFloat = 0
    ) {
        let fullText = description != nil ? "\(title)\n\(description!)" : title

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

        if let description = description,
           let descriptionStyle = descriptionStyle,
           let descriptionColor = descriptionColor {
            let descriptionRange = (fullText as NSString).range(of: description)
            attributedString.addAttributes([
                .font: descriptionStyle.font,
                .foregroundColor: descriptionColor,
                .paragraphStyle: paragraphStyle,
                .kern: descriptionStyle.fontSize * (descriptionStyle.letterSpacingPercent / 100)
            ], range: descriptionRange)
        }

        titleLabel.attributedText = attributedString
    }

    public func updatePage(current: Int, total: Int) {
        self.currentPage = current
        self.entirePage = total
        updatePageLabel()
    }

    private func updatePageLabel() {
        let fullText = "\(currentPage)/\(entirePage)"
        let attributedText = NSMutableAttributedString(string: fullText)

        let slashIndex = "\(currentPage)".count
        attributedText.addAttribute(.foregroundColor, value: AppColor.purple70, range: NSRange(location: 0, length: slashIndex))
        attributedText.addAttribute(.foregroundColor, value: AppColor.gray70, range: NSRange(location: slashIndex, length: fullText.count - slashIndex))

        pageLabel.attributedText = attributedText
    }
}
