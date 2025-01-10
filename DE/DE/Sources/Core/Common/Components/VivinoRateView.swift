// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Cosmos
import Then
import CoreModule

public class VivinoRateView: UIView {
    
    public var score = 4.0 {
        didSet {
            updateScore()
        }
    }
    
    public func updateScore() {
        if score == 0.0 {
            scoreLabel.isHidden = true
            scoreStar.isHidden = true
            noRatingLabel.isHidden = false
        } else {
            scoreLabel.isHidden = false
            scoreStar.isHidden = false
            noRatingLabel.isHidden = true
            
            let text = "\(score) / 5.0"
            let attributedString = NSMutableAttributedString(string: text)
            
            // 전체 텍스트 스타일 설정
            attributedString.addAttributes(
                [
                    .foregroundColor: AppColor.gray70!,
                    .font: UIFont.ptdRegularFont(ofSize: 12)
                ],
                range: NSRange(location: 0, length: text.count)
            )
            
            // `score` 부분 스타일 설정
            if let range = text.range(of: "\(score)") {
                let nsRange = NSRange(range, in: text)
                attributedString.addAttributes(
                    [
                        .foregroundColor: Constants.AppColor.purple100 ?? .purple,
                        .font: UIFont.ptdSemiBoldFont(ofSize: 18)
                    ],
                    range: nsRange
                )
            }
            
            scoreLabel.attributedText = attributedString
            scoreStar.rating = score
        }
    }
    
    private lazy var noRatingLabel = UILabel().then {
        $0.text = "비비노 평점이 없습니다."
        $0.textColor = AppColor.gray70
        $0.font = UIFont.ptdRegularFont(ofSize: 14)
        $0.isHidden = true
    }
    
    private let title = TitleWithBarView(title: "Vivino Rate", subTitle: "비비노 평점")
    
    public lazy var scoreLabel = UILabel()
    
    public lazy var scoreStar = CosmosView().then {
        $0.rating = score
        $0.settings.updateOnTouch = false
        $0.settings.starSize = 25
        $0.settings.starMargin = 6.14
        $0.settings.filledColor = AppColor.purple100!
        $0.settings.filledBorderColor = AppColor.purple100!
        $0.settings.emptyColor = AppColor.gray30!
        $0.settings.emptyBorderColor = AppColor.gray30!
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Constants.AppColor.grayBG
        self.addComponents()
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addComponents() {
        [title, scoreLabel, scoreStar, noRatingLabel].forEach{ self.addSubview($0) }
    }
    
    private func constraints() {
        title.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        scoreLabel.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(26)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(24)
        }
        
        scoreStar.snp.makeConstraints {
            $0.centerY.equalTo(scoreLabel)
            $0.leading.equalTo(scoreLabel.snp.trailing).offset(26)
            $0.bottom.equalToSuperview()
        }
        
        noRatingLabel.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(16)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(24)
        }
    }
    
    public func configure(_ model: WineViVinoRatingModel) {
        self.score = model.vivinoRating
    }
}
