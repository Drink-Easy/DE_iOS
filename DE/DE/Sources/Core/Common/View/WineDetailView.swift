// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import SDWebImage

public class WineDetailView: UIView {
    
    // 이미지 그림자 전용 뷰 (그림자만 표시)
    public lazy var shadowContainerView = UIView().then {
        $0.layer.shadowOpacity = 0.07
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.layer.shadowRadius = 10.5
        if traitCollection.userInterfaceStyle == .dark {
            $0.layer.shadowColor = .none
        } else {
            $0.layer.shadowColor = AppColor.black?.cgColor
        }
    }

    // 실제 콘텐츠를 담는 뷰 (cornerRadius 적용)
    public lazy var image = UIImageView().then {
        $0.image = UIImage(named: "스파클링")
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFit
    }
    
    public lazy var labelView = UIView().then {
        $0.backgroundColor = AppColor.white
        $0.layer.cornerRadius = 14
        $0.layer.masksToBounds = true
        if traitCollection.userInterfaceStyle == .dark {
            $0.layer.shadowColor = .none
        } else {
            $0.layer.shadowColor = AppColor.black?.cgColor
        }
        $0.layer.shadowOpacity = 0.07
        $0.layer.shadowOffset = CGSize(width: 0, height: 1)
        $0.layer.shadowRadius = 10.5
        $0.layer.masksToBounds = false
    }
    
    private func createTitle(text: String) ->  UILabel {
        return UILabel().then {
            $0.text = text
            $0.textColor = AppColor.purple100
            $0.font = UIFont.ptdSemiBoldFont(ofSize: 14)
        }
    }
    
    private func createContents(text: String) -> UILabel {
        return UILabel().then {
            $0.text = text
            $0.textColor = AppColor.black
            $0.font = UIFont.ptdMediumFont(ofSize: 12)
        }
    }
    
    private func makeStackView(arrangedSubviews: [UIView]) -> UIStackView {
        return UIStackView(arrangedSubviews: arrangedSubviews).then {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .fill
            $0.distribution = .fill
        }
    }
    
    private lazy var kind = createTitle(text: "종류")
    private lazy var type = createTitle(text: "품종")
    private lazy var country = createTitle(text: "생산지")
    public lazy var kindContents = createContents(text: "스파클링 와인, 샴페인")
    public lazy var typeContents = createContents(text: "피노누아(60%), 샤르도네(40%)")
    public lazy var countryContents = createContents(text: "프랑스, 상파뉴")
    
    private lazy var titleStackView = makeStackView(arrangedSubviews: [kind, type, country])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColor.bgGray
        self.addComponents()
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func addComponents() {
        [shadowContainerView, labelView].forEach{ self.addSubview($0) }
        shadowContainerView.addSubview(imageBackground)
        imageBackground.addSubview(image)
        [titleStackView, kindContents, typeContents, countryContents].forEach{ labelView.addSubview($0) }
    }
    
    private func constraints() {
        shadowContainerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        imageBackground.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        image.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(3)
            $0.horizontalEdges.equalToSuperview()
        }
        
        labelView.snp.makeConstraints {
            $0.centerY.equalTo(imageBackground)
            $0.leading.equalTo(imageBackground.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(imageBackground.snp.height)
            $0.bottom.equalToSuperview()
        }
        
        titleStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(13)
            $0.width.equalTo(38)
        }
        
        kindContents.snp.makeConstraints {
            $0.leading.equalTo(titleStackView.snp.trailing).offset(18)
            $0.centerY.equalTo(kind)
            $0.trailing.equalToSuperview().offset(-13)
        }
        
        typeContents.snp.makeConstraints {
            $0.leading.equalTo(titleStackView.snp.trailing).offset(18)
            $0.centerY.equalTo(type)
            $0.trailing.equalToSuperview().offset(-13)
        }
        
        countryContents.snp.makeConstraints {
            $0.leading.equalTo(titleStackView.snp.trailing).offset(18)
            $0.centerY.equalTo(country)
            $0.trailing.equalToSuperview().offset(-13)
        }
    }
    
    public func configure(_ model: WineDetailInfoModel) {
        if let url = URL(string: model.image) {
            image.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            image.image = UIImage(named: "placeholder")
        }
        kindContents.text = model.sort
        typeContents.text = model.variety
        countryContents.text = "\(model.country), \(model.region)"
    }
}
