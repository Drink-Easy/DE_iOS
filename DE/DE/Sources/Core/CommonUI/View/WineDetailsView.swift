// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then
import DesignSystem

public class WineDetailsView: UIView {
    
    private let title = TitleWithoutBarView(title: "Details", subTitle: "상세 와인 정보")
    
    private let sort = UILabel()
    private let variety = UILabel()
    private lazy var country = UILabel()
    
    public lazy var sortContents = UILabel()
    public lazy var varietyContents = UILabel()
    public lazy var countryContents = UILabel()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        addSubviews(title, sort, variety, country, sortContents, varietyContents, countryContents)
        
        AppTextStyle.KR.body2.apply(to: sort, text: "종류", color: AppColor.gray50)
        AppTextStyle.KR.body2.apply(to: variety, text: "품종", color: AppColor.gray50)
        AppTextStyle.KR.body2.apply(to: country, text: "생산지", color: AppColor.gray50)
        
        [sortContents, varietyContents, countryContents].forEach {
            $0.numberOfLines = 0
            $0.lineBreakStrategy = .hangulWordPriority
        }
    }
    
    private func setupLayout() {
        title.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(24)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(30)
        }
        
        sort.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
        }
        
        sortContents.snp.makeConstraints {
            $0.top.equalTo(sort.snp.top)
            $0.leading.equalTo(sort.snp.trailing).offset(41)
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        variety.snp.makeConstraints {
            $0.top.equalTo(sortContents.snp.bottom).offset(8)
            $0.leading.equalTo(sort.snp.leading)
        }
        
        varietyContents.snp.makeConstraints {
            $0.top.equalTo(variety.snp.top)
            $0.leading.equalTo(variety.snp.trailing).offset(41)
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        country.snp.makeConstraints {
            $0.top.equalTo(varietyContents.snp.bottom).offset(8)
            $0.leading.equalTo(variety.snp.leading)
        }

        countryContents.snp.makeConstraints {
            $0.top.equalTo(country.snp.top)
            $0.leading.equalTo(country.snp.trailing).offset(29)
            $0.trailing.lessThanOrEqualToSuperview()
            $0.bottom.equalToSuperview().inset(24)
        }
    }
    
    public func configure(_ model: WineDetailInfoModel) {
        AppTextStyle.KR.body3.apply(to: sortContents, text: model.sort, color: AppColor.gray100)
        AppTextStyle.KR.body3.apply(to: varietyContents, text: model.variety, color: AppColor.gray100)
        AppTextStyle.KR.body3.apply(to: countryContents, text: "\(model.country), \(model.region)", color: AppColor.gray100)
        
        self.layoutIfNeeded()
    }
}
