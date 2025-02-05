// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule
import Cosmos
import Network

public class WineInfoView: UIView {
    weak var delegate: PropertyHeaderDelegate? {
        didSet {
            updateDelegates() // Delegate가 설정될 때 업데이트
        }
    }
    
    private let wineColorManager = WineColorManager()
    
    // MARK: - UI Components
    lazy var header = MyNoteTopView()
    
    //디테일 뷰 담을 껍데기
    let backgroundView = UIView().then {
        $0.backgroundColor = AppColor.tnbg
        $0.layer.cornerRadius = 10
        
        $0.layer.shadowColor = UIColor.black.cgColor  // 그림자 색상
        $0.layer.shadowOpacity = 0.1                 // 그림자 투명도 (0 ~ 1)
        $0.layer.shadowOffset = CGSize(width: 0, height: 4) // 그림자 위치 (x, y)
        $0.layer.shadowRadius = 10                   // 그림자 퍼짐 정도
    }
    
    private let detailContentView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 32
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    //그래프 뷰
    let chartStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .fill
        $0.alignment = .fill
    }
    let chartHeaderView = PropertyTitleView(type: .palateGraph)
    let chartView = PolygonChartView()
    
    // 컬러 뷰
    let colorStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .fill
        $0.alignment = .fill
    }
    let colorHeaderView = PropertyTitleView(type: .color)
    lazy var colorBodyView = UIView()
    
    lazy var colorView = UIView().then {
        $0.layer.cornerRadius = 6
    }
    lazy var colorLabel = UILabel().then {
        $0.font = .ptdMediumFont(ofSize: 14)
        $0.textColor = AppColor.gray90
    }
    
    //노즈 뷰
    let noseStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .fill
        $0.alignment = .fill
    }
    let noseHeaderView = PropertyTitleView(type: .nose)
    let noseView = UILabel().then {
        $0.text = ""
        $0.font = .ptdMediumFont(ofSize: 14)
        $0.textColor = AppColor.gray90
        $0.numberOfLines = 0
    }
    
    //별점 뷰
    let ratingStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .fill
        $0.alignment = .fill
    }
    let ratingHeaderView = PropertyTitleView(type: .rate)
    public lazy var ratingView = UIView()
    public var ratingValue: Double = 2.5 {
        didSet {
            updateRatingLabel()
        }
    }
    
    public func setRatingValue(_ value: Double) {
        self.ratingValue = value
    }
    
    private func updateRatingLabel() {
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
        
        ratingLabel.attributedText = attributedString
    }

    public lazy var ratingLabel: UILabel = {
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
        r.isUserInteractionEnabled = false
        r.rating = 2.5
        r.settings.fillMode = .half
        r.settings.emptyBorderColor = .clear
        r.settings.filledBorderColor = .clear
        r.settings.starSize = 24
        r.settings.starMargin = 6
        r.settings.filledColor = AppColor.purple100!
        r.settings.emptyColor = AppColor.gray30!

        return r
    }()
    
    //리뷰 뷰
    let reviewStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .fill
        $0.alignment = .fill
    }
    let reviewHeaderView = PropertyTitleView(type: .review)
    let dateView = UILabel().then {
        $0.font = .ptdMediumFont(ofSize: 14)
        $0.textColor = AppColor.gray90
        $0.numberOfLines = 0
        $0.lineBreakStrategy = .standard // 줄바꿈 전략 선택(한글모드 안함)
    }
    let reviewView = UILabel().then {
        $0.font = .ptdMediumFont(ofSize: 14)
        $0.textColor = AppColor.gray90
        $0.numberOfLines = 0
        $0.lineBreakStrategy = .standard // 줄바꿈 전략 선택(한글모드 안함)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        chartHeaderView.setName(eng: "Palate Graph", kor: "팔렛 그래프")
        chartHeaderView.enableEditButton()
        colorHeaderView.setName(eng: "Color", kor: "색상")
        colorHeaderView.enableEditButton()
        noseHeaderView.setName(eng: "Nose", kor: "향")
        noseHeaderView.enableEditButton()
        ratingHeaderView.setName(eng: "Rate", kor: "평점")
        ratingHeaderView.enableEditButton()
        reviewHeaderView.setName(eng: "Review", kor: "후기")
        reviewHeaderView.enableEditButton()
        updateDelegates()
        setupUI()
        setupConstraints()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateDelegates() {
            [chartHeaderView, colorHeaderView, noseHeaderView, ratingHeaderView, reviewHeaderView].forEach {
                $0.delegate = delegate
            }
        }
    
    private func setupUI() {
        [ratingLabel, ratingButton].forEach{ ratingView.addSubview($0) }
        [colorView, colorLabel].forEach{ colorBodyView.addSubview($0) }
        [chartHeaderView, chartView].forEach {
            chartStackView.addArrangedSubview($0) // addArrangedSubview로 추가
        }
        [colorHeaderView, colorBodyView].forEach {
            colorStackView.addArrangedSubview($0) // addArrangedSubview로 추가
        }
        [noseHeaderView, noseView].forEach {
            noseStackView.addArrangedSubview($0) // addArrangedSubview로 추가
        }
        [ratingHeaderView, ratingView].forEach {
            ratingStackView.addArrangedSubview($0) // addArrangedSubview로 추가
        }
        [reviewHeaderView, dateView, reviewView].forEach {
            reviewStackView.addArrangedSubview($0) // addArrangedSubview로 추가
        }
        
        [chartStackView, colorStackView, noseStackView, ratingStackView, reviewStackView].forEach {
            detailContentView.addArrangedSubview($0) // addArrangedSubview로 추가
        }
        
        addSubview(header)
        addSubview(backgroundView)
        backgroundView.addSubview(detailContentView)
    }
    
    private func setupConstraints() {
        header.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(200)
        }
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(24) // 콘텐츠 크기에 따라 조정
        }
        
        detailContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16) // 내부 여백 16pt
        }
        
        [chartHeaderView, colorHeaderView, noseHeaderView, ratingHeaderView, reviewHeaderView].forEach {
            $0.snp.makeConstraints { make in
                make.height.greaterThanOrEqualTo(30) // 고정 높이
            }
        }
        chartView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(Constants.superViewHeight * 0.45)
        }
        colorView.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.leading.equalToSuperview()
        }
        colorLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.leading.equalTo(colorView.snp.trailing).offset(8)
        }
        
        colorBodyView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(30)
            make.leading.trailing.equalToSuperview().offset(6)
        }
        
        noseView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(30)
            make.leading.trailing.equalToSuperview().offset(6)
        }
        ratingView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(30)
            make.leading.trailing.equalToSuperview()
        }
        ratingLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(6)
            make.width.equalTo(80)
        }
        
        ratingButton.snp.makeConstraints { make in
            make.centerY.equalTo(ratingLabel.snp.centerY)
            make.leading.equalTo(ratingLabel.snp.trailing)
        }
        dateView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(15)
            make.leading.trailing.equalToSuperview().inset(6)
        }
        reviewView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(30)
            make.leading.trailing.equalToSuperview().inset(6)
        }
    }
}
