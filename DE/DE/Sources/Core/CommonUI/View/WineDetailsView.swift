// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then
import DesignSystem

public class WineDetailsView: UIView {
    
    private let title = TitleWithBarView(title: "Details", subTitle: "상세 와인 정보")
    
    private func createTitle(text: String) ->  UILabel {
        return UILabel().then {
            $0.text = text
            $0.textColor = AppColor.black
            $0.font = UIFont.pretendard(.medium, size: 18)
        }
    }
    
    private func createContents(text: String) ->  UILabel {
        return UILabel().then {
            $0.text = text
            $0.textColor = AppColor.black
            $0.font = UIFont.pretendard(.regular, size: 14)
            $0.numberOfLines = 0
        }
    }
    
    private lazy var sort = createTitle(text: "종류")
    private lazy var variety = createTitle(text: "품종")
    private lazy var country = createTitle(text: "생산지")
    public lazy var sortContents = createContents(text: "")
    public lazy var varietyContents = createContents(text: "")
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
        self.addSubviews(title, sort, variety, country, sortContents, varietyContents, countryContents)
    
    }
    
    private func constraints() {
        title.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(24)
            $0.leading.trailing.equalToSuperview()
        }
        
        sort.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(16)
            $0.leading.equalToSuperview()
        }
        
        variety.snp.makeConstraints {
            $0.top.equalTo(sort.snp.bottom).offset(16)
            $0.leading.equalTo(sort.snp.leading)
        }
        country.snp.makeConstraints {
            $0.top.equalTo(variety.snp.bottom).offset(16)
            $0.leading.equalTo(variety.snp.leading)
        }
        
        sortContents.snp.makeConstraints {
            $0.centerY.equalTo(sort)
            $0.leading.equalTo(safeAreaLayoutGuide).offset(89)
            $0.trailing.equalToSuperview()
        }
        varietyContents.snp.makeConstraints {
            $0.centerY.equalTo(variety)
            $0.leading.equalTo(sortContents.snp.leading)
            $0.trailing.equalToSuperview()
        }
        countryContents.snp.makeConstraints {
            $0.centerY.equalTo(country)
            $0.leading.equalTo(sortContents.snp.leading)
            $0.trailing.equalToSuperview()
            //$0.height.equalTo(50)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
    
    public func configure(_ model: WineDetailInfoModel) {
        sortContents.text = model.sort
        varietyContents.text = model.variety
        countryContents.text = "\(model.country), \(model.region)"
        self.layoutIfNeeded()
    }
}
