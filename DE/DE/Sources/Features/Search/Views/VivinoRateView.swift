// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import Cosmos
import Then
import CoreModule

class VivinoRateView: UIView {
    
    public var score = 4.0 {
        didSet {
            updateScore()
        }
    }
    
    public func updateScore() {
        scoreLabel.text = "\(score) / 5.0"
        scoreStar.rating = score
    }
    
    private let title = TitleWithBarView(title: "Vivino Rate", subTitle: "비비노 평점")
    
    public lazy var scoreLabel = UILabel().then {
        let text = "\(score) / 5.0"
        $0.text = text
        let attributedString = NSMutableAttributedString(string: text)
        
        attributedString.addAttributes(
            [
                .foregroundColor: UIColor(hue: 0, saturation: 0, brightness: 0.6, alpha: 1.0),
                .font: UIFont.ptdRegularFont(ofSize: 12)
            ],
            range: NSRange(location: 0, length: text.count)
        )
        
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
        $0.attributedText = attributedString
    }
    
    public lazy var scoreStar = CosmosView().then {
        $0.rating = score
        $0.settings.updateOnTouch = false
        $0.settings.starSize = 25
        $0.settings.starMargin = 6.14
        $0.settings.filledColor = Constants.AppColor.purple100 ?? .purple
        $0.settings.filledBorderColor = Constants.AppColor.purple100 ?? .purple
        $0.settings.emptyColor = UIColor(hue: 0, saturation: 0, brightness: 0.85, alpha: 1.0)
        $0.settings.emptyBorderColor = UIColor(hue: 0, saturation: 0, brightness: 0.85, alpha: 1.0)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Constants.AppColor.grayBG
        self.addComponents()
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addComponents() {
        [title, scoreLabel, scoreStar].forEach{ self.addSubview($0) }
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
    }
    
    public func configure(_ model: WineViVinoRatingModel) {
        self.score = model.vivinoRating
    }
}
