// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then
import DesignSystem

public class ReviewCollectionViewCell: UICollectionViewCell {
    
    public static let identifier = "ReviewCollectionViewCell"
    var isExpanded = false
    private var toggleBottomConstraint: Constraint?
    private var reviewBottomConstraint: Constraint?
    public var onToggle: (() -> Void)?
    
    public lazy var nickname = UILabel().then {
        $0.textColor = AppColor.gray100
        $0.font = UIFont.pretendard(.medium, size: 16)
    }
    
    public lazy var score = UILabel()
    
    public lazy var review = UILabel()
    
    public lazy var date = UILabel().then {
        $0.textColor = AppColor.gray50
        $0.font = UIFont.pretendard(.regular, size: 12)
    }
    
    private let toggleButton = UIButton().then {
        $0.setTitle("더보기", for: .normal)
        $0.titleLabel?.font = UIFont.pretendard(.medium, size: 13)
        $0.setTitleColor(AppColor.gray70, for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.isHidden = true
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = AppColor.gray05
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        self.addComponents()
        self.constraints()
        
        toggleButton.addTarget(self, action: #selector(toggleButtonTapped), for: .touchUpInside)
    }
    
    @objc private func toggleButtonTapped() {
        isExpanded.toggle()
        review.numberOfLines = isExpanded ? 0 : 2
        toggleButton.setTitle(isExpanded ? "접기" : "더보기", for: .normal)
        onToggle?()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        contentView.addSubviews(nickname, score, review, date, toggleButton)
    }
    
    private func constraints() {
        nickname.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalToSuperview().offset(17)
        }
        
        score.snp.makeConstraints {
            $0.centerY.equalTo(nickname)
            $0.leading.equalTo(nickname.snp.trailing).offset(8)
        }
        
        review.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(17)
            $0.top.equalTo(nickname.snp.bottom).offset(7)
            self.reviewBottomConstraint = $0.bottom.equalToSuperview().offset(-12).constraint
        }
        
        date.snp.makeConstraints {
            $0.centerY.equalTo(score)
            $0.trailing.equalToSuperview().offset(-17)
        }
        
        toggleButton.snp.makeConstraints {
            $0.top.equalTo(review.snp.bottom).offset(2)
            $0.leading.equalTo(review.snp.leading)
            $0.bottom.equalToSuperview().offset(-10)
            self.toggleBottomConstraint = $0.bottom.equalToSuperview().offset(-12).constraint
        }
    }
    
    public func configure(model: WineReviewModel, isExpanded: Bool) {
        AppTextStyle.KR.body1.apply(to: nickname, text: model.name, color: AppColor.gray100)
        AppTextStyle.KR.body2
            .apply(to: score, text: "★ \(String(model.rating))", color: AppColor.purple100)
        AppTextStyle.KR.body3.apply(to: review, text: model.contents, color: AppColor.gray90)
        
        if let data = model.createdAt.toFlexibleDotFormattedDate() {
            date.text = data
        }
        
        self.isExpanded = isExpanded
        review.numberOfLines = isExpanded ? 0 : 2
        toggleButton.setTitle(isExpanded ? "접기" : "더보기", for: .normal)
        let shouldShowToggle = isReviewTextTruncated()
        toggleButton.isHidden = !shouldShowToggle
        
        // 리뷰내 2줄 초과인지 아닌지에 따른 제약 활성화/비활성화
        if shouldShowToggle {
            toggleBottomConstraint?.activate()
            reviewBottomConstraint?.deactivate()
        } else {
            toggleBottomConstraint?.deactivate()
            reviewBottomConstraint?.activate()
        }
    }
    
    private func isReviewTextTruncated() -> Bool {
        guard let text = review.text else { return false }
        
        let labelWidth = contentView.frame.width - 30
        let labelFont = review.font ?? UIFont.systemFont(ofSize: 16)
        let lineSpacing = review.font.pointSize * 0.3
        let numberOfLines = text.numberOfLines(width: labelWidth, font: labelFont, lineSpacing: lineSpacing)
        return numberOfLines > 2
    }
}
