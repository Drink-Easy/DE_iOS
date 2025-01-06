// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
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
    
    lazy var wineName: UILabel = {
        let w = UILabel()
        w.text = "루이 로드레 크리스탈 2015"
        w.textColor = .black
        w.textAlignment = .center
        w.font = UIFont(name: "Pretendard-SemiBold", size: 24)
        return w
    }()
    
    lazy var wineImage: UIImageView = {
        let w = UIImageView()
        w.contentMode = .scaleToFill
        w.layer.cornerRadius = 12
        w.clipsToBounds = true
        return w
    }()
    
    lazy var descriptionView = DescriptionUIView().then {
        $0.layer.cornerRadius = 14
        $0.backgroundColor = .white
    }
    
    private let graphView: UIView = {
        let g = UIView()
        g.backgroundColor = .white
        g.layer.cornerRadius = 10
        return g
    }()
    
    private let graphLabel: UILabel = {
        let g = UILabel()
        g.text = "Palate Graph"
        g.font = UIFont.ptdSemiBoldFont(ofSize: 20)
        g.textColor = .black
        return g
    }()
    
    private let graphKoreanLabel: UILabel = {
        let g = UILabel()
        g.text = "팔렛 그래프"
        g.font = .ptdRegularFont(ofSize: 12)
        g.textColor = AppColor.gray90
        return g
    }()
    
    let changeGraph: UILabel = {
        let c = UILabel()
        c.text = "수정하기"
        c.font = .ptdRegularFont(ofSize: 12)
        c.textColor = AppColor.gray90
        c.isUserInteractionEnabled = true
        c.tag = 3
        return c
    }()
    
    private let graphVector: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#B06FCD")
        return v
    }()
    
    let polygonChart: PolygonChartView = {
        let p = PolygonChartView()
        return p
    }()
    
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
        a.textAlignment = .center
        return a
    }()
    
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
        backgroundColor = AppColor.gray20
        addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
        }
        
        contentView.addSubview(wineName)
        wineName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(25)
        }
        
        contentView.addSubview(wineImage)
        wineImage.snp.makeConstraints { make in
            make.top.equalTo(wineName.snp.bottom).offset(20)
            make.leading.equalTo(wineName.snp.leading)
            make.width.height.equalTo(100)
        }
        
        contentView.addSubview(descriptionView)
        descriptionView.snp.makeConstraints { make in
            make.top.bottom.equalTo(wineImage)
            make.leading.equalTo(wineImage.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-24)
        }
        
        contentView.addSubview(graphView)
        graphView.snp.makeConstraints { make in
            make.top.equalTo(descriptionView.snp.bottom).offset(24)
            make.leading.equalTo(wineImage.snp.leading)
            make.centerX.equalToSuperview()
            make.height.greaterThanOrEqualTo(880)
        }
        
        graphView.addSubview(graphLabel)
        graphLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(24)
        }
        
        graphView.addSubview(graphKoreanLabel)
        graphKoreanLabel.snp.makeConstraints { make in
            make.top.equalTo(graphLabel.snp.top).offset(4)
            make.leading.equalTo(graphLabel.snp.trailing).offset(10)
        }
        
        graphView.addSubview(changeGraph)
        changeGraph.snp.makeConstraints { make in
            make.top.equalTo(graphKoreanLabel)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        graphView.addSubview(graphVector)
        graphVector.snp.makeConstraints { make in
            make.top.equalTo(graphLabel.snp.bottom).offset(6)
            make.leading.equalTo(graphLabel.snp.leading).offset(-4)
            make.height.equalTo(1)
            make.centerX.equalToSuperview()
        }
        
        graphView.addSubview(polygonChart)
        polygonChart.snp.makeConstraints { make in
            make.top.equalTo(graphVector.snp.bottom).offset(62)
            make.leading.equalTo(graphVector.snp.leading)
            make.centerX.equalTo(graphVector.snp.centerX)
            make.height.greaterThanOrEqualTo(312)
        }
        
        graphView.addSubview(colorLabel)
        colorLabel.snp.makeConstraints { make in
            make.top.equalTo(polygonChart.snp.bottom).offset(40)
            make.leading.equalTo(graphLabel)
        }
        
        graphView.addSubview(colorLabelKorean)
        colorLabelKorean.snp.makeConstraints { make in
            make.top.equalTo(colorLabel.snp.top).offset(3)
            make.leading.equalTo(colorLabel.snp.trailing).offset(10)
        }
        
        graphView.addSubview(changeColor)
        changeColor.snp.makeConstraints { make in
            make.top.equalTo(colorLabelKorean.snp.top).offset(1)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        graphView.addSubview(colorVector)
        colorVector.snp.makeConstraints { make in
            make.top.equalTo(colorLabel.snp.bottom).offset(5.06)
            make.leading.trailing.equalTo(graphVector)
            make.height.equalTo(1)
            
        }
        
        graphView.addSubview(colorBox)
        colorBox.snp.makeConstraints { make in
            make.top.equalTo(colorVector.snp.bottom).offset(10)
            make.leading.equalTo(colorVector.snp.leading).offset(6)
            make.width.height.greaterThanOrEqualTo(30)
        }
        
        graphView.addSubview(colorName)
        colorName.snp.makeConstraints { make in
            make.top.equalTo(colorBox.snp.top).offset(6)
            make.centerY.equalTo(colorBox.snp.centerY)
            make.leading.equalTo(colorBox.snp.trailing).offset(12)
        }
        
        graphView.addSubview(noseLabel)
        noseLabel.snp.makeConstraints { make in
            make.top.equalTo(colorBox.snp.bottom).offset(30)
            make.leading.equalTo(colorLabel.snp.leading)
        }
        
        graphView.addSubview(noseLabelKorean)
        noseLabelKorean.snp.makeConstraints { make in
            make.top.equalTo(noseLabel.snp.top).offset(3)
            make.leading.equalTo(noseLabel.snp.trailing).offset(10)
        }
        
        graphView.addSubview(changeNose)
        changeNose.snp.makeConstraints { make in
            make.top.equalTo(noseLabelKorean.snp.top).offset(1)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        graphView.addSubview(noseVector)
        noseVector.snp.makeConstraints { make in
            make.top.equalTo(noseLabel.snp.bottom).offset(5.06)
            make.leading.trailing.equalTo(colorVector)
            make.height.equalTo(1)
        }
        
        graphView.addSubview(noseDescriptionLabel)
        noseDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(noseVector.snp.bottom).offset(10)
            make.leading.equalTo(noseVector.snp.leading).offset(6)
        }
        
        graphView.addSubview(rateLabel)
        rateLabel.snp.makeConstraints { make in
            make.top.equalTo(noseDescriptionLabel.snp.bottom).offset(30)
            make.leading.equalTo(noseLabel.snp.leading)
        }
        
        graphView.addSubview(rateKoreanLabel)
        rateKoreanLabel.snp.makeConstraints { make in
            make.top.equalTo(rateLabel.snp.top).offset(3)
            make.leading.equalTo(rateLabel.snp.trailing).offset(10)
        }
        
        graphView.addSubview(changeRate)
        changeRate.snp.makeConstraints { make in
            make.top.equalTo(rateKoreanLabel.snp.top).offset(1)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        graphView.addSubview(rateVector)
        rateVector.snp.makeConstraints { make in
            make.top.equalTo(rateLabel.snp.bottom).offset(5.06)
            make.leading.trailing.equalTo(noseVector)
            make.height.equalTo(1)
        }
        
        graphView.addSubview(ratingLabel)
        ratingLabel.snp.makeConstraints { make in
            make.top.equalTo(rateVector.snp.bottom).offset(10)
            make.leading.equalTo(rateVector.snp.leading).offset(6)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        
        graphView.addSubview(ratingButton)
        ratingButton.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.top).offset(-2)
            make.centerY.equalTo(ratingLabel.snp.centerY)
            make.leading.equalTo(ratingLabel.snp.trailing).offset(11.5)
        }
        
        graphView.addSubview(reviewLabel)
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingButton.snp.bottom).offset(30)
            make.leading.equalTo(rateLabel.snp.leading)
        }
        
        graphView.addSubview(reviewKoreanLabel)
        reviewKoreanLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.top).offset(3)
            make.leading.equalTo(reviewLabel.snp.trailing).offset(10)
        }
        
        graphView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewKoreanLabel.snp.top).offset(1)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        graphView.addSubview(reviewVector)
        reviewVector.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(5.06)
            make.leading.trailing.equalTo(rateVector)
            make.height.equalTo(1)
        }
        
        graphView.addSubview(reviewDescription)
        reviewDescription.snp.makeConstraints { make in
            make.leading.equalTo(reviewVector.snp.leading).offset(6)
            make.centerX.equalTo(reviewVector.snp.centerX)
            make.top.equalTo(reviewVector.snp.bottom).offset(10)
        }
       
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(graphView.snp.bottom).offset(31)
        }
        
    }
    
    func updateUI(_ data: TastingNoteResponsesDTO) {
        wineName.text = data.wineName
        wineImage.sd_setImage(with: URL(string: data.imageUrl), placeholderImage: UIImage())
        descriptionView.kindDescription.text = data.sort
        // descriptionView.breedDescription.text = data.
        descriptionView.fromDescription.text = data.area
        colorBox.backgroundColor = UIColor(hex: data.color)
        ratingLabel.text = "\(data.rating) / 5.0"
        ratingButton.rating = data.rating
        // updateRatingLabel(with: data.rating)
        dateLabel.text = data.tasteDate
        reviewDescription.text = data.review
        noseDescriptionLabel.text = data.noseMapList.compactMap { $0.values.first }.joined(separator: ", ")
        
        let chartData = [
            RadarChartData(type: .sweetness, value: data.sugarContent),
            RadarChartData(type: .acid, value: data.acidity),
            RadarChartData(type: .tannin, value: data.tannin),
            RadarChartData(type: .bodied, value: data.body),
            RadarChartData(type: .alcohol, value: data.alcohol)
        ]
        polygonChart.dataList = chartData
        
        self.layoutIfNeeded()
    }
    
    private func updateRatingLabel(with rating: Double) {
        ratingLabel.text = String(format: "%.1f / 5.0", rating)
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
