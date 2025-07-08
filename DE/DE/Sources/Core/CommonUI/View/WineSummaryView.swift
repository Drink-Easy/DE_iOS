// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then
import DesignSystem
import Cosmos

public class WineSummaryView: UIView {
  
    var wineName: String = "" {
        didSet {
            AppTextStyle.KR.subtitle1.apply(to: largeTitleLabel, text: wineName, color: AppColor.black)
        }
    }
    
    var score : Double = 0.0 {
        didSet {
            scoreStar.rating = score
            AppTextStyle.KR.body2.apply(to: ratingLabel, text: "\(score)", color: AppColor.gray70)
        }
    }
    
    private func createTitle(text: String) ->  UILabel {
        return UILabel().then {
            $0.text = text
            $0.textColor = AppColor.gray70
            $0.font = UIFont.pretendard(.semiBold, size: 14)
        }
    }
    
    private func createContents(text: String) ->  UILabel {
        return UILabel().then {
            $0.text = text
            $0.textColor = AppColor.black
            $0.font = UIFont.pretendard(.medium, size: 12)
            $0.numberOfLines = 0
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
    
    private lazy var sort = createTitle(text: "종류")
    private lazy var country = createTitle(text: "생산국")
    public lazy var sortContents = createContents(text: "")
    public lazy var countryContents = createContents(text: "")

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
    
    }
    
    private func constraints() {
        largeTitleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(23)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(24)
        }
        scoreStar.snp.makeConstraints {
            $0.top.equalTo(largeTitleLabel.snp.bottom).offset(6)
            $0.leading.equalTo(safeAreaLayoutGuide).inset(24)
        }
        ratingLabel.snp.makeConstraints {
            $0.centerY.equalTo(scoreStar)
            $0.leading.equalTo(scoreStar.snp.trailing).offset(6)
        }
        sort.snp.makeConstraints {
            $0.top.equalTo(scoreStar.snp.bottom).offset(20)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(24)
        }
        
        country.snp.makeConstraints {
            $0.top.equalTo(sort.snp.bottom).offset(9)
            $0.leading.equalTo(sort.snp.leading)
        }
        
        sortContents.snp.makeConstraints {
            $0.centerY.equalTo(sort)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(89)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-26)
        }
        
        countryContents.snp.makeConstraints {
            $0.top.equalTo(country.snp.top)
            $0.leading.equalTo(sortContents.snp.leading)
            $0.trailing.equalTo(safeAreaLayoutGuide).offset(-26)
            //$0.height.equalTo(50)
            $0.bottom.equalToSuperview()
        }
    
    }
    
    public func configure(_ model: WineDetailInfoModel) {
        self.wineName = model.wineName
        self.score = model.rating
        sortContents.text = model.sort
        countryContents.text = model.country
        self.layoutIfNeeded()
    }
}
