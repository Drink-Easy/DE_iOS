// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then
import DesignSystem
import Cosmos

public class WineSummaryView: UIView {
    var wineName: String = "" {
        didSet {
            AppTextStyle.KR.head.apply(to: largeTitleLabel, text: wineName, color: AppColor.black)
        }
    }
    
    var score : Double = 0.0 {
        didSet {
            scoreStar.rating = score
            AppTextStyle.KR.body2.apply(to: ratingLabel, text: "\(score)", color: AppColor.gray90)
        }
    }
    
    public lazy var largeTitleLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    
    public lazy var scoreStar = CosmosView().then {
        $0.rating = score
        $0.settings.fillMode = .precise
        $0.settings.updateOnTouch = false
        $0.settings.starSize = 18
        $0.settings.starMargin = 1
        $0.settings.filledColor = AppColor.purple100
        $0.settings.filledBorderColor = AppColor.purple100
        $0.settings.emptyColor = AppColor.gray30
        $0.settings.emptyBorderColor = AppColor.gray30
    }
    
    private lazy var ratingLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    
    private lazy var sort = UILabel()
    private lazy var country = UILabel()
    public lazy var sortContents = UILabel()
    public lazy var countryContents = UILabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        self.addComponents()
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addComponents() {
        self.addSubviews(largeTitleLabel, scoreStar, ratingLabel, sort, country, sortContents, countryContents)
    
        AppTextStyle.KR.body2.apply(to: sort, text: "종류", color: AppColor.gray50)
        AppTextStyle.KR.body2.apply(to: country, text: "생산국", color: AppColor.gray50)
        sortContents.numberOfLines = 1
        sortContents.lineBreakMode = .byTruncatingTail
        countryContents.numberOfLines = 1
        countryContents.lineBreakMode = .byTruncatingTail
    }
    
    private func constraints() {
        largeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        scoreStar.snp.makeConstraints {
            $0.top.equalTo(largeTitleLabel.snp.bottom).offset(6)
            $0.leading.equalTo(safeAreaLayoutGuide)
        }
        
        ratingLabel.snp.makeConstraints {
            $0.centerY.equalTo(scoreStar)
            $0.leading.equalTo(scoreStar.snp.trailing).offset(6)
        }
        
        sort.snp.makeConstraints {
            $0.top.equalTo(scoreStar.snp.bottom).offset(14)
            $0.leading.equalTo(safeAreaLayoutGuide)
        }
        
        country.snp.makeConstraints {
            $0.top.equalTo(sort.snp.bottom).offset(5)
            $0.leading.equalTo(sort.snp.leading)
        }
        
        sortContents.snp.makeConstraints {
            $0.centerY.equalTo(sort)
            $0.leading.equalTo(sort.snp.trailing).offset(39)
            $0.trailing.lessThanOrEqualTo(safeAreaLayoutGuide)
        }
        
        countryContents.snp.makeConstraints {
            $0.top.equalTo(country.snp.top)
            $0.leading.equalTo(sortContents.snp.leading)
            $0.trailing.lessThanOrEqualTo(safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    
    }
    
    public func configure(_ model: WineDetailInfoModel) {
        self.wineName = model.wineName
        self.score = model.rating
        AppTextStyle.KR.body2.apply(to: sortContents, text: model.sort, color: AppColor.gray100)
        AppTextStyle.KR.body2.apply(to: countryContents, text: model.country, color: AppColor.gray100)
        self.layoutIfNeeded()
    }
    
    public func setforTN(){
        self.scoreStar.isHidden = true
        self.ratingLabel.isHidden = true
        
        self.largeTitleLabel.lineBreakMode = .byTruncatingTail
        self.scoreStar.snp.removeConstraints()
        self.ratingLabel.snp.removeConstraints()
        
        self.largeTitleLabel.snp.remakeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(safeAreaLayoutGuide)
            $0.width.equalTo(DynamicPadding.dynamicValue(230))
        }
        
        self.sort.snp.remakeConstraints {
            $0.top.equalTo(largeTitleLabel.snp.bottom).offset(20)
            $0.leading.equalTo(safeAreaLayoutGuide)
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
