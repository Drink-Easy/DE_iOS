// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Cosmos
import CoreModule
import Then

class RatingWineView: UIView {
    // 탑 - 와인 정보
    public lazy var header = TopView(currentPage: 5, entirePage: 5)
    public lazy var infoView = WineDetailView()
    
    // 별점
    public lazy var ratingHeader = PropertyTitleView()
    public lazy var ratingBody = UIView()
    public lazy var ratingLabel: UILabel = {
        let ratingValue: Double = 2.5
        let r = UILabel()
        r.text = "\(ratingValue) / 5.0"
        r.textColor = AppColor.gray90!
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
    
    // 리뷰
    public lazy var reviewHeader = PropertyTitleView()
    public lazy var reviewBody: UITextView = {
        let r = UITextView()
        r.layer.cornerRadius = 10
        r.textColor = AppColor.gray90!
        r.font = .ptdMediumFont(ofSize: 14)
        r.backgroundColor = AppColor.gray10
        return r
    }()

    // 버튼
    public lazy var saveButton = CustomButton(title: "저장하기", isEnabled: true)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        ratingHeader.setName(eng: "Rate", kor: "별점")
        reviewHeader.setName(eng: "Review", kor: "리뷰")
        
        addComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setWineName(_ name: String) {
        self.header.setTitleLabel(name)
    }
    
    private func addComponents() {
        [ratingLabel, ratingButton].forEach{ ratingBody.addSubview($0) }
        [header, infoView, ratingHeader, ratingBody, reviewHeader, reviewBody, saveButton].forEach{ addSubview($0) }
    }
    
    private func setConstraints() {
        header.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(62)
        }
        
        infoView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(20) // TODO : 동적 기기 대응
            make.leading.trailing.equalToSuperview()
        }
        
        ratingHeader.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(50) // TODO : 동적 기기 대응
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(30)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }
        ratingButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(ratingLabel.snp.trailing).offset(25)
        }
        
        ratingBody.snp.makeConstraints { make in
            make.top.equalTo(ratingHeader.snp.bottom).offset(24) // TODO : 동적 기기 대응
            make.leading.equalTo(ratingHeader.snp.leading)
            make.trailing.equalTo(ratingHeader.snp.trailing)
        }
        
        reviewHeader.snp.makeConstraints { make in
            make.top.equalTo(ratingBody.snp.bottom).offset(60) // TODO : 동적 기기 대응
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(30)
        }
        
        reviewBody.snp.makeConstraints { make in
            make.top.equalTo(reviewHeader.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(180) // 웬만하면 고정. 버튼 영역 침범 안되도록
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(40) // 동적 기기 대응
            make.leading.trailing.equalToSuperview()
        }
    }
}
