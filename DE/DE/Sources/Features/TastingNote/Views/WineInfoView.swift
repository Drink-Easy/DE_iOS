// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule
import Cosmos
import Network

public class WineInfoView: UIView {
    
    let scrollView: UIScrollView = {
        let s = UIScrollView()
        return s
    }()
    
    let contentView: UIView = {
        let c = UIView()
        c.backgroundColor = AppColor.gray20
        return c
    }()
    
    //TODO: 헤더, 와인 인포 뷰 추가
    
    
    //디테일 뷰 담을 배경 뷰
    let backgroundView = UIView().then {
        $0.backgroundColor = AppColor.white
    }
    
    //그래프 뷰
    let chartView: PolygonChartView = {
        let p = PolygonChartView()
        return p
    }()
    
    //TODO: 컬러 뷰
    let colorLabel: UILabel = {
        let c = UILabel()
        c.text = "Color"
        c.font = .ptdBoldFont(ofSize: 20)
        return c
    }()
    
    let colorLabelKorean: UILabel = {
        let c = UILabel()
        c.text = "색상"
        c.font = .ptdRegularFont(ofSize: 14)
        c.textColor = AppColor.gray90
        return c
    }()
    
    let changeColor: UILabel = {
        let c = UILabel()
        c.text = "수정하기"
        c.font = .ptdRegularFont(ofSize: 12)
        c.textColor = AppColor.gray90
        c.isUserInteractionEnabled = true
        c.tag = 0
        return c
    }()
    
    let colorVector: UIView = {
        let r = UIView()
        r.backgroundColor = AppColor.gray30
        return r
    }()
    
    let colorBox: UIView = {
        let r = UIView()
        r.backgroundColor = .black
        r.layer.cornerRadius = 6
        return r
    }()
    
    let colorName: UILabel = {
        let c = UILabel()
        c.text = "스위트 콘"
        c.font = .ptdMediumFont(ofSize: 14)
        c.textColor = AppColor.gray70
        return c
    }()
    
    //TODO: 노즈 뷰
    private let noseLabel: UILabel = {
        let a = UILabel()
        a.text = "Nose"
        a.textColor = .black
        a.font = UIFont.ptdSemiBoldFont(ofSize: 20)
        a.textAlignment = .center
        return a
    }()
    
    let noseLabelKorean: UILabel = {
        let c = UILabel()
        c.text = "향"
        c.font = .ptdRegularFont(ofSize: 14)
        c.textColor = AppColor.gray90
        return c
    }()
    
    let changeNose: UILabel = {
        let c = UILabel()
        c.text = "수정하기"
        c.font = .ptdRegularFont(ofSize: 12)
        c.textColor = AppColor.gray90
        c.isUserInteractionEnabled = true
        c.tag = 1
        return c
    }()
    
    
    let noseVector: UIView = {
        let r = UIView()
        r.backgroundColor = AppColor.gray30
        return r
    }()
    
    private let noseDescriptionLabel: UILabel = {
        let a = UILabel()
        a.text = "API"
        a.textColor = AppColor.gray70
        a.font = UIFont.ptdSemiBoldFont(ofSize: 14)
        a.textAlignment = .left
        a.numberOfLines = 0
        return a
    }()
    
    //TODO: 별점 뷰
    private let rateLabel: UILabel = {
        let r = UILabel()
        r.text = "Rate"
        r.font = UIFont.ptdSemiBoldFont(ofSize: 20)
        r.textColor = .black
        r.textAlignment = .center
        return r
    }()
    
    let rateKoreanLabel: UILabel = {
        let c = UILabel()
        c.text = "평점"
        c.font = .ptdRegularFont(ofSize: 14)
        c.textColor = AppColor.gray90
        return c
    }()
    
    let changeRate: UILabel = {
        let c = UILabel()
        c.text = "수정하기"
        c.font = .ptdRegularFont(ofSize: 12)
        c.textColor = AppColor.gray90
        c.isUserInteractionEnabled = true
        c.tag = 2
        return c
    }()
    
    private let rateVector: UIView = {
        let r = UIView()
        r.backgroundColor = AppColor.gray30
        return r
    }()
    
    private let ratingButton: CosmosView = {
        let r = CosmosView()
        r.rating = 2.5
        r.settings.fillMode = .half
        r.settings.emptyBorderColor = .clear
        r.settings.filledBorderColor = .clear
        r.settings.starSize = 20
        r.settings.starMargin = 5
        r.settings.filledColor = UIColor(hex: "#7E13B1")!
        r.settings.emptyColor = UIColor(hex: "D9D9D9")!
        r.isUserInteractionEnabled = false
        return r
    }()
    
    private let ratingLabel: UILabel = {
        let ratingValue: Double = 2.5
        let r = UILabel()
        r.text = "\(ratingValue) / 5.0"
        r.textColor = .black
        r.font = .ptdSemiBoldFont(ofSize: 13)
        return r
    }()
    
    //TODO: 리뷰 뷰
    private let reviewLabel: UILabel = {
        let r = UILabel()
        r.text = "Review"
        r.textColor = .black
        r.font = .ptdSemiBoldFont(ofSize: 20)
        r.textAlignment = .center
        return r
    }()
    
    private let reviewKoreanLabel: UILabel = {
        let c = UILabel()
        c.text = "후기"
        c.font = .ptdRegularFont(ofSize: 14)
        c.textColor = AppColor.gray90
        return c
    }()
    
    let dateLabel: UILabel = {
        let d = UILabel()
        d.textColor = AppColor.gray70
        d.font = .ptdMediumFont(ofSize: 10)
        d.textAlignment = .center
        return d
    }()
    
    private let reviewVector: UIView = {
        let r = UIView()
        r.backgroundColor = UIColor(hex: "DBDBDB")
        return r
    }()
    
    private let reviewDescription: UILabel = {
        let r = UILabel()
        r.text = "API"
        r.textColor = AppColor.gray90
        r.font = UIFont.ptdMediumFont(ofSize: 14)
        r.textAlignment = .left
        r.isUserInteractionEnabled = false
        return r
    }()
    
    func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        [backgroundView].forEach{
            contentView.addSubview($0)
        }
        
        [chartView].forEach{
            backgroundView.addSubview($0)
        }
    }
    
    func setupConstraints() {
        // scrollView 제약 조건
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // 화면 전체에 맞춤
        }
        
        // contentView 제약 조건
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview() // 가로 크기를 scrollView에 맞춤
        }
        
        // backgroundView 제약 조건
        backgroundView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24) // 상단 여백 추가
            make.leading.trailing.equalToSuperview() // 좌우 화면에 맞춤
            make.height.equalTo(Constants.superViewHeight * 0.5) // 높이 설정
        }
        
        // chartView 제약 조건
        chartView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.top).offset(16)
            make.leading.equalTo(backgroundView.snp.leading).offset(16)
            make.trailing.equalTo(backgroundView.snp.trailing).offset(-16)
            make.height.equalTo(200) // 고정 높이
        }
        
        // contentView의 하단 제약 조건
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(backgroundView.snp.bottom).offset(40)
        }
    }
    
    func updateUI(_ data: TastingNoteResponsesDTO) {

        
        self.layoutIfNeeded()
    }
    
    private func updateRatingLabel(with rating: Double) {
        ratingLabel.text = String(format: "%.1f / 5.0", rating)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        chartView.propertyHeader.setName(eng: "Palate", kor: "맛")
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
