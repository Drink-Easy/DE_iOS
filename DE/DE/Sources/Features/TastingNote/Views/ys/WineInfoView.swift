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
    
    // MARK: - UI Components
    lazy var header = MyNoteTopView()
    
    //디테일 뷰 담을 껍데기
    let backgroundView = UIView().then {
        $0.backgroundColor = AppColor.white
        $0.layer.cornerRadius = 10
    }
    
    private let detailContentView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    //그래프 뷰
    let chartHeaderView = PropertyTitleView(type: .palateGraph)
    let chartView = PolygonChartView()
    
    //TODO: 컬러 뷰
    let colorHeaderView = PropertyTitleView(type: .color)
    let colorView = UIView().then {
        $0.backgroundColor = .red
    }
    
    //TODO: 노즈 뷰
    let noseHeaderView = PropertyTitleView(type: .nose)
    let noseView = UIView().then {
        $0.backgroundColor = .blue
    }
    
    //TODO: 별점 뷰
    let ratingHeaderView = PropertyTitleView(type: .rate)
    let ratingView = UIView().then {
        $0.backgroundColor = .green
    }
    
    //TODO: 리뷰 뷰
    let reviewHeaderView = PropertyTitleView(type: .review)
    let reviewView = UIView().then {
        $0.backgroundColor = .brown
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
        [chartHeaderView, chartView, colorHeaderView, colorView, noseHeaderView, noseView, ratingHeaderView, ratingView, reviewHeaderView, reviewView].forEach {
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
            make.height.greaterThanOrEqualTo(200) // 고정 높이
        }
        colorView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(30)
        }
        noseView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(30)
        }
        ratingView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(30)
        }
        reviewView.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(30)
        }
    }
}
