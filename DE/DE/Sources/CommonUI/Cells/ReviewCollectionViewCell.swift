// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

public class ReviewCollectionViewCell: UICollectionViewCell {
    
    public static let identifier = "ReviewCollectionViewCell"
    var isExpanded = false
    public var onToggle: (() -> Void)?
    
    public lazy var nickname = UILabel().then {
        $0.textColor = AppColor.black
        $0.font = UIFont.pretendard(.medium, size: 16)
    }
    
    public lazy var score = UILabel().then {
        $0.textColor = AppColor.purple100
        $0.font = UIFont.pretendard(.medium, size: 14)
    }
    
    public lazy var review = UILabel().then {
        $0.numberOfLines = 0
        $0.textColor = AppColor.gray70
        $0.font = UIFont.pretendard(.medium, size: 14)
        $0.numberOfLines = 2
        $0.setLineSpacingPercentage(0.3)
    }
    
    public lazy var date = UILabel().then {
        $0.textColor = AppColor.gray90
        $0.font = UIFont.pretendard(.regular, size: 12)
    }
    
    private let toggleButton = UIButton().then {
        $0.setTitle("더보기", for: .normal)
        $0.titleLabel?.font = UIFont.pretendard(.medium, size: 13)
        $0.setTitleColor(AppColor.gray50, for: .normal)
        $0.isHidden = true
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = AppColor.gray10
        contentView.layer.cornerRadius = 14
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
        [nickname, score, review, date, toggleButton].forEach { contentView.addSubview($0) }
    }
    
    private func constraints() {
        nickname.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.equalToSuperview().offset(18)
        }
        
        score.snp.makeConstraints {
            $0.centerY.equalTo(nickname)
            $0.leading.equalTo(nickname.snp.trailing).offset(8)
        }
        
        review.snp.makeConstraints {
            $0.leading.equalTo(nickname.snp.leading)
            $0.trailing.equalToSuperview().offset(-12)
            $0.top.equalTo(nickname.snp.bottom).offset(7)
        }
        
        date.snp.makeConstraints {
            $0.centerY.equalTo(score)
            $0.trailing.equalToSuperview().offset(-12)
        }
        
        toggleButton.snp.makeConstraints {
            $0.top.equalTo(review.snp.bottom).offset(2)
            $0.leading.equalTo(review.snp.leading)
        }
    }
    
    public func configure(model: WineReviewModel, isExpanded: Bool) {
        nickname.text = model.name
        score.text = "★ \(String(model.rating))"
        review.text = model.contents
        let input = model.createdAt
        if let range = input.range(of: "T") {
            let result = String(input[..<range.lowerBound])
            date.text = result
        }
        
        self.isExpanded = isExpanded
        review.setLineSpacingPercentage(0.3)
        review.numberOfLines = isExpanded ? 0 : 2
        toggleButton.setTitle(isExpanded ? "접기" : "더보기", for: .normal)
        toggleButton.isHidden = !isReviewTextTruncated()
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
