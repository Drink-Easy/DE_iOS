// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Cosmos
import CoreModule
import Then

class OnlyRateView: UIView {
    // 탑 - 와인 정보
    public lazy var header = WineNameView()
    public lazy var infoView = WineDetailView()
    
    // 별점
    public lazy var ratingHeader = PropertyTitleView(type: .rate)
    public lazy var ratingBody = UIView()
    public lazy var ratingLabel: UILabel = {
        let ratingValue: Double = 2.5
        let r = UILabel()
        
        let fullText = "\(ratingValue) / 5.0"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        let ratingRange = (fullText as NSString).range(of: "\(ratingValue)")
        attributedString.addAttributes([
            .font: UIFont.ptdSemiBoldFont(ofSize: 18),
            .foregroundColor: AppColor.purple100!
        ], range: ratingRange)
        
        let defaultRange = (fullText as NSString).range(of: "/ 5.0")
        attributedString.addAttributes([
            .font: UIFont.ptdRegularFont(ofSize: 12),
            .foregroundColor: AppColor.gray90!
        ], range: defaultRange)
        
        r.attributedText = attributedString
        return r
    }()
    
    public lazy var ratingButton: CosmosView = {
        let r = CosmosView()
        r.rating = 2.5
        r.settings.fillMode = .half
        r.settings.emptyBorderColor = .clear
        r.settings.filledBorderColor = .clear
        r.settings.starSize = 20
        r.settings.starMargin = 5
        r.settings.filledColor = AppColor.purple100!
        r.settings.emptyColor = AppColor.gray30!
        return r
    }()

    // 버튼
    public lazy var saveButton = CustomButton(title: "저장하기", isEnabled: true)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        ratingHeader.setName(eng: "Rate", kor: "별점")
        
        addComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setWineName(_ name: String) {
        self.header.setTitleLabel(name)
    }
    
    public func setRate(_ rate: Double) {
        // 새 텍스트 설정
        let fullText = "\(rate) / 5.0"
        let attributedString = NSMutableAttributedString(string: fullText)
        
        // rate 스타일 설정
        let ratingRange = (fullText as NSString).range(of: "\(rate)")
        attributedString.addAttributes([
            .font: UIFont.ptdSemiBoldFont(ofSize: 18),
            .foregroundColor: AppColor.purple100!
        ], range: ratingRange)
        
        // 나머지 텍스트 스타일 설정
        let defaultRange = (fullText as NSString).range(of: "/ 5.0")
        attributedString.addAttributes([
            .font: UIFont.ptdRegularFont(ofSize: 12),
            .foregroundColor: AppColor.gray90!
        ], range: defaultRange)
        
        ratingLabel.attributedText = attributedString
    }
    
    private func addComponents() {
        [ratingLabel, ratingButton].forEach{ ratingBody.addSubview($0) }
        [header, infoView, ratingHeader, ratingBody, saveButton].forEach{ addSubview($0) }
    }
    
    private func setConstraints() {
        header.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(62)
        }
        
        infoView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(DynamicPadding.dynamicValue(20))
            make.leading.trailing.equalToSuperview()
        }
        
        ratingHeader.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(DynamicPadding.dynamicValue(50))
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(30)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(80)
        }
        
        ratingButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(ratingLabel.snp.trailing).offset(25)
        }
        
        ratingBody.snp.makeConstraints { make in
            make.top.equalTo(ratingHeader.snp.bottom).offset(DynamicPadding.dynamicValue(24))
            make.leading.equalTo(ratingHeader.snp.leading)
            make.trailing.equalTo(ratingHeader.snp.trailing)
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(DynamicPadding.dynamicValue(40))
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
    }
}
