//
//  WineInfoView.swift
//  Drink-EG
//
//  Created by 이수현 on 10/30/24.
//

import UIKit
import SnapKit
import Cosmos
import CoreModule
import Then

class RatingWineView: UIView {
    
    let scrollView: UIScrollView = {
        let s = UIScrollView()
        return s
    }()
    
    let contentView: UIView = {
        let c = UIView()
        c.backgroundColor = AppColor.gray20
        return c
    }()
    
    private let wineName: UILabel = {
        let w = UILabel()
        w.text = "루이 로드레 크리스탈 2015"
        w.textColor = .black
        w.textAlignment = .center
        w.font = UIFont(name: "Pretendard-SemiBold", size: 24)
        return w
    }()
    
    private let wineImage: UIImageView = {
        let w = UIImageView()
        w.contentMode = .scaleToFill
        w.image = UIImage(named: "wine1")
        w.layer.cornerRadius = 14
        return w
    }()
    
    let descriptionView = DescriptionUIView().then {
        $0.layer.cornerRadius = 14
        $0.backgroundColor = .white
    }
    
    private let rateLabel: UILabel = {
        let r = UILabel()
        r.text = "Rate"
        r.font = UIFont.ptdBoldFont(ofSize: 14)
        return r
    }()
    
    private let rateLabelKorean: UILabel = {
        let r = UILabel()
        r.text = "별점"
        r.font = .ptdRegularFont(ofSize: 14)
        r.textColor = AppColor.gray80
        return r
    }()
    
    private let rateVector: UIView = {
        let r = UIView()
        r.backgroundColor = AppColor.purple50
        return r
    }()
    
    let ratingLabel: UILabel = {
            let ratingValue: Double = 2.5
            let r = UILabel()
            r.text = "\(ratingValue) / 5.0"
            r.textColor = UIColor(hex: "#999999")
            return r
        }()
    
    let ratingButton: CosmosView = {
        let r = CosmosView()
        r.rating = 2.5
        r.settings.fillMode = .half
        r.settings.emptyBorderColor = .clear
        r.settings.starSize = 20
        r.settings.starMargin = 5
        r.settings.filledColor = UIColor(hex: "#7E13B1")!
        r.settings.emptyColor = UIColor(hex: "D9D9D9")!
        return r
    }()
    
    private let reviewLabel: UILabel = {
        let r = UILabel()
        r.text = "Review"
        r.font = .ptdSemiBoldFont(ofSize: 20)
        r.textColor = .black
        return r
    }()
    
    private let reviewLabelKorean: UILabel = {
        let r = UILabel()
        r.text = "리뷰"
        r.font = .ptdRegularFont(ofSize: 14)
        r.textColor = AppColor.gray80
        return r
    }()
    
    private let reviewVector: UIView = {
        let r = UIView()
        r.backgroundColor = AppColor.purple50
        return r
    }()
    
    let reviewTextField: UITextView = {
        let r = UITextView()
        // r.placeholder = "추가적으로 기록하고 싶은 것들을 기록해 보세요 !"
        r.textColor = AppColor.gray80
        r.font = .ptdMediumFont(ofSize: 14)
        r.backgroundColor = .white
        return r
    }()
    
    let saveButton: UIButton = {
        let n = UIButton()
        n.setTitle("저장하기", for: .normal)
        n.titleLabel?.font = .ptdBoldFont(ofSize: 18)
        n.setTitleColor(.white, for: .normal)
        n.backgroundColor = AppColor.purple100
        n.layer.cornerRadius = 14
        return n
    }()
    
    func setupUI() {
        backgroundColor = AppColor.gray20
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        contentView.addSubview(wineName)
        wineName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(25)
        }
        
        contentView.addSubview(wineImage)
        wineImage.snp.makeConstraints { make in
            make.top.equalTo(wineName.snp.bottom).offset(20)
            make.leading.equalTo(wineName)
            make.width.height.equalTo(Constants.superViewHeight*0.1)
        }
        
        contentView.addSubview(descriptionView)
        descriptionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(wineImage)
            make.leading.equalTo(wineImage.snp.trailing).offset(8)
            //make.trailing.equalToSuperview().offset(24)
        }
        
        contentView.addSubview(rateLabel)
        rateLabel.snp.makeConstraints { make in
            make.top.equalTo(wineImage.snp.bottom).offset(66)
            make.leading.equalTo(wineImage)
        }
        
        contentView.addSubview(rateLabelKorean)
        rateLabelKorean.snp.makeConstraints { make in
            make.top.equalTo(rateLabel.snp.top).offset(4)
            make.centerY.equalTo(rateLabel.snp.centerY)
            make.leading.equalTo(rateLabel.snp.trailing).offset(6)
        }
        
        contentView.addSubview(rateVector)
        rateVector.snp.makeConstraints { make in
            make.top.equalTo(rateLabel.snp.bottom).offset(6)
            make.leading.equalTo(rateLabel)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        
        contentView.addSubview(ratingLabel)
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(rateVector.snp.bottom).offset(26)
            make.leading.equalTo(rateVector)
        }
        
        contentView.addSubview(ratingButton)
        ratingButton.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel)
            make.leading.equalTo(ratingLabel.snp.trailing).offset(26)
        }
        
        contentView.addSubview(reviewLabel)
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.bottom).offset(80)
            make.leading.equalTo(ratingLabel)
        }
        
        contentView.addSubview(reviewLabelKorean)
        reviewLabelKorean.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.top).offset(4)
            make.leading.equalTo(reviewLabel.snp.trailing).offset(6)
            make.centerY.equalTo(reviewLabel.snp.centerY)
        }
        
        contentView.addSubview(reviewVector)
        reviewVector.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(6)
            make.leading.equalTo(reviewLabel.snp.leading)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        
        contentView.addSubview(reviewTextField)
        reviewTextField.snp.makeConstraints { make in
            make.top.equalTo(reviewVector.snp.bottom).offset(26)
            make.leading.equalTo(reviewVector)
            make.centerX.equalToSuperview()
            make.height.equalTo(300)
        }
        
        contentView.addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(reviewTextField.snp.bottom).offset(30)
            make.leading.equalTo(reviewTextField.snp.leading).offset(4)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(56)
        }
        
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(saveButton.snp.bottom).offset(34)
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
