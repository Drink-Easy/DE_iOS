// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then
import DesignSystem

public class ReviewView: UIView {
    
    public var score = 4.0 {
        didSet {
            updateScore()
        }
    }
    
    public lazy var noReviewLabel = UILabel().then {
        $0.text = "작성된 리뷰가 없습니다."
        $0.textColor = AppColor.gray70
        $0.font = UIFont.pretendard(.regular, size: 14)
        $0.isHidden = true
    }
    
    private let title = TitleWithBarView(title: "Review", subTitle: "리뷰")
    
    public func updateScore() {
        let text = "\(score) / 5.0"
        let attributedString = NSMutableAttributedString(string: text)
        
        // 전체 텍스트 스타일 설정
        attributedString.addAttributes(
            [
                .foregroundColor: AppColor.gray70,
                .font: UIFont.pretendard(.regular, size: 12)
            ],
            range: NSRange(location: 0, length: text.count)
        )
        
        // `score` 부분 스타일 설정
        if let range = text.range(of: "\(score)") {
            let nsRange = NSRange(range, in: text)
            attributedString.addAttributes(
                [
                    .foregroundColor: AppColor.purple100,
                    .font: UIFont.pretendard(.semiBold, size: 18)
                ],
                range: nsRange
            )
        }
        
        scoreLabel.attributedText = attributedString
    }
    
    public lazy var scoreLabel = UILabel()
    
    public lazy var moreBtn = UIButton().then {
        
        var configuration = UIButton.Configuration.plain()
        // 이미지 설정
        configuration.image = UIImage(systemName: "chevron.forward")?.withRenderingMode(.alwaysOriginal).withTintColor(AppColor.gray50)
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 10, weight: .regular) // 원하는 크기
        configuration.preferredSymbolConfigurationForImage = symbolConfiguration
        
        configuration.imagePlacement = .trailing
        configuration.imagePadding = 2

        // 타이틀 속성 설정
        let attributes: AttributeContainer = AttributeContainer([
            .font: UIFont.pretendard(.medium, size: 12), .foregroundColor: AppColor.gray50])
        configuration.attributedTitle = AttributedString("더보기", attributes: attributes)
        configuration.titleAlignment = .center
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 0)

        $0.configuration = configuration
        $0.backgroundColor = .clear
    }
    
    public lazy var reviewCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumInteritemSpacing = 8
        $0.estimatedItemSize = .zero
    }).then {
        $0.register(ReviewCollectionViewCell.self, forCellWithReuseIdentifier: ReviewCollectionViewCell.identifier)
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColor.background
        self.addComponents()
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addComponents() {
        [title, moreBtn, reviewCollectionView, noReviewLabel].forEach{ self.addSubview($0) }
        title.addSubview(scoreLabel)
    }
    
    private func constraints() {
        title.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        scoreLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-4)
        }
        
        moreBtn.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(25)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-24)
        }
        
        reviewCollectionView.snp.makeConstraints {
            $0.top.equalTo(moreBtn.snp.bottom).offset(8)
            $0.height.equalTo(332)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            $0.bottom.equalToSuperview()
        }
        
        noReviewLabel.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(16)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(24)
        }
        noReviewLabel.sizeToFit()
    }
    
    public func configure(_ model: WineAverageReviewModel) {
        score = model.avgMemberRating
    }
}
