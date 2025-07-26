// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule
import DesignSystem
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
    lazy var header = WineSummaryView()
    
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
    
    lazy var wineImageView = WineImageView()
    //디테일 뷰 담을 껍데기
    let backgroundView = UIView().then {
        $0.backgroundColor = .clear
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
        $0.font = .pretendard(.medium, size: 14)
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
        $0.font = .pretendard(.medium, size: 14)
        $0.textColor = AppColor.gray90
        $0.numberOfLines = 0
    }
    
    let divider1 = DividerFactory.make()
    let divider2 = DividerFactory.make()
    let divider3 = DividerFactory.make()
    let thinDivider = DividerFactory.make()
    
    public var ratingValue: Double = 2.5 {
        didSet {
            scoreStar.rating = ratingValue
            AppTextStyle.KR.body2.apply(to: ratingLabel, text: "\(ratingValue)", color: AppColor.purple100)
        }
    }
    
    public func setRatingValue(_ value: Double) {
        self.ratingValue = value
    }

    private lazy var ratingLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    
    //리뷰 뷰
    let reviewStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .fill
        $0.alignment = .fill
    }
    let reviewHeaderView = PropertyTitleView(type: .review)
    lazy var reviewBodyView = UIView()
    public lazy var scoreStar = CosmosView().then {
        $0.rating = ratingValue
        $0.settings.fillMode = .precise
        $0.settings.updateOnTouch = false
        $0.settings.starSize = 18
        $0.settings.starMargin = 1
        $0.settings.filledColor = AppColor.purple100
        $0.settings.filledBorderColor = AppColor.purple100
        $0.settings.emptyColor = AppColor.gray30
        $0.settings.emptyBorderColor = AppColor.gray30
    }
    let dateView = UILabel().then {
        $0.font = .pretendard(.medium, size: 14)
        $0.textColor = AppColor.gray90
        $0.numberOfLines = 0
        $0.lineBreakStrategy = .standard // 줄바꿈 전략 선택(한글모드 안함)
    }
    let reviewView = UILabel().then {
        $0.font = .pretendard(.medium, size: 14)
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
        reviewHeaderView.setName(eng: "Review", kor: "후기")
        reviewHeaderView.enableEditButton()
        updateDelegates()
        setupUI()
        setupConstraints()
        header.setforTN()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateDelegates() {
            [chartHeaderView, colorHeaderView, noseHeaderView, reviewHeaderView].forEach {
                $0.delegate = delegate
            }
        }
    
    private func setupUI() {
        [colorView, colorLabel].forEach{ colorBodyView.addSubview($0) }
        [scoreStar, ratingLabel, dateView].forEach{ reviewBodyView.addSubview($0) }
        [chartHeaderView, chartView].forEach {
            chartStackView.addArrangedSubview($0) // addArrangedSubview로 추가
        }
        [colorHeaderView, colorBodyView].forEach {
            colorStackView.addArrangedSubview($0) // addArrangedSubview로 추가
        }
        [noseHeaderView, noseView].forEach {
            noseStackView.addArrangedSubview($0) // addArrangedSubview로 추가
        }
        [reviewHeaderView, reviewBodyView, reviewView].forEach {
            reviewStackView.addArrangedSubview($0) // addArrangedSubview로 추가
        }
        
        [divider1, chartStackView, divider2, colorStackView, thinDivider, noseStackView, divider3, reviewStackView].forEach {
            detailContentView.addArrangedSubview($0) // addArrangedSubview로 추가
        }
        
        self.addSubviews(header, wineImageView, backgroundView)
        backgroundView.addSubview(detailContentView)
    }
    
    private func setupConstraints() {
        header.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.greaterThanOrEqualTo(100)
        }
        wineImageView.snp.makeConstraints { make in
//            make.top.equalToSuperview()
            make.centerY.equalTo(header)
            make.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
            make.height.width.equalTo(DynamicPadding.dynamicValue(116))
        }
        divider1.snp.makeConstraints {
            $0.top.equalTo(header.snp.bottom).offset(DynamicPadding.dynamicValue(24))
            $0.height.equalTo(8)
            $0.horizontalEdges.equalToSuperview()
        }
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(24) // 콘텐츠 크기에 따라 조정
        }
        
        detailContentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        [chartHeaderView, colorHeaderView, noseHeaderView, reviewHeaderView].forEach {
            $0.snp.makeConstraints { make in
                make.height.greaterThanOrEqualTo(30) // 고정 높이
            }
        }
        [chartStackView, colorStackView, noseStackView, reviewStackView].forEach {
            $0.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
                make.trailing.equalToSuperview().offset(DynamicPadding.dynamicValue(24))
            }
        }
        chartView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(Constants.superViewHeight * 0.45)
        }
        divider2.snp.makeConstraints {
            $0.top.equalTo(chartView.snp.bottom)
            $0.height.equalTo(8)
            $0.horizontalEdges.equalToSuperview()
        }
        colorView.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.leading.equalToSuperview()
        }
        colorLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.centerY.equalTo(colorView)
            make.leading.equalTo(colorView.snp.trailing).offset(8)
        }
        thinDivider.snp.makeConstraints {
            $0.top.equalTo(colorView.snp.bottom).offset(DynamicPadding.dynamicValue(24))
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
        }
        colorBodyView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(30)
            make.leading.trailing.equalToSuperview()
        }
        
        noseView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(30)
            make.leading.trailing.equalToSuperview()
        }
        divider3.snp.makeConstraints {
            $0.top.equalTo(noseView.snp.bottom).offset(DynamicPadding.dynamicValue(24))
            $0.height.equalTo(8)
            $0.horizontalEdges.equalToSuperview()
        }
        reviewBodyView.snp.makeConstraints { make in
//            make.height.greaterThanOrEqualTo(30)
            make.leading.trailing.equalToSuperview()
        }
        
        scoreStar.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
        }
        ratingLabel.snp.makeConstraints {
            $0.centerY.equalTo(scoreStar)
            $0.leading.equalTo(scoreStar.snp.trailing).offset(6)
        }
        dateView.snp.makeConstraints { make in
//            make.height.greaterThanOrEqualTo(15)
            make.centerY.equalTo(ratingLabel)
            make.trailing.equalToSuperview().inset(DynamicPadding.dynamicValue(24))
        }
        reviewView.snp.makeConstraints { make in
            
            make.height.greaterThanOrEqualTo(30)
            make.leading.trailing.equalToSuperview()
        }
    }
}
