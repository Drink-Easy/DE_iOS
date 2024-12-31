// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import Cosmos

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
    
    private let descriptionView = DescriptionUIView().then {
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
        g.text = "Graph"
        g.font = UIFont.ptdBoldFont(ofSize: 14)
        g.textColor = .black
        return g
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
    
    private let rateLabel: UILabel = {
        let r = UILabel()
        r.text = "Rate"
        r.font = UIFont.ptdBoldFont(ofSize: 14)
        return r
    }()
    
    private let rateVector: UIView = {
        let r = UIView()
        r.backgroundColor = UIColor(hex: "#DBDBDB")
        return r
    }()
    
    private let ratingButton: CosmosView = {
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
    
    private let ratingLabel: UILabel = {
        let ratingValue: Double = 2.5
        let r = UILabel()
        r.text = "\(ratingValue) / 5.0"
        r.textColor = UIColor(hex: "#999999")
        return r
    }()
    
    private let tastingNoteLabel: UILabel = {
        let t = UILabel()
        t.text = "Tasting Notes"
        t.font = UIFont.ptdBoldFont(ofSize: 14)
        t.textColor = .black
        return t
    }()
    
    private let tastingNoteVector: UIView = {
        let t = UIView()
        t.backgroundColor = UIColor(hex: "#DBDBDB")
        return t
    }()
    
    private let aromaLabel: UILabel = {
        let a = UILabel()
        a.text = "Aroma"
        a.textColor = .black
        a.font = UIFont.ptdSemiBoldFont(ofSize: 13)
        a.textAlignment = .center
        return a
    }()
    
    private let aromaDescriptionLabel: UILabel = {
        let a = UILabel()
        a.text = "API"
        a.textColor = .black
        a.font = UIFont.ptdSemiBoldFont(ofSize: 11)
        a.textAlignment = .center
        return a
    }()
    
    private let tasteLabel: UILabel = {
        let a = UILabel()
        a.text = "Taste"
        a.textColor = .black
        a.font = UIFont.ptdSemiBoldFont(ofSize: 13)
        a.textAlignment = .center
        return a
    }()
    
    private let tasteDescriptionLabel: UILabel = {
        let a = UILabel()
        a.text = "API"
        a.textColor = .black
        a.font = UIFont.ptdSemiBoldFont(ofSize: 11)
        a.textAlignment = .center
        return a
    }()
    
    private let finishLabel: UILabel = {
        let a = UILabel()
        a.text = "Finish"
        a.textColor = .black
        a.font = UIFont.ptdSemiBoldFont(ofSize: 13)
        a.textAlignment = .center
        return a
    }()
    
    private let finishDescriptionLabel: UILabel = {
        let a = UILabel()
        a.text = "API"
        a.textColor = .black
        a.font = UIFont.ptdSemiBoldFont(ofSize: 11)
        a.textAlignment = .center
        return a
    }()
    
    private let reviewLabel: UILabel = {
        let r = UILabel()
        r.text = "Review"
        r.textColor = .black
        r.font = UIFont.ptdSemiBoldFont(ofSize: 14)
        r.textAlignment = .center
        return r
    }()
    
    private let reviewVector: UIView = {
        let r = UIView()
        r.backgroundColor = UIColor(hex: "DBDBDB")
        return r
    }()
    
    private let reviewDescription: UILabel = {
        let r = UILabel()
        r.text = "API"
        r.textColor = .black
        r.font = UIFont.ptdMediumFont(ofSize: 11)
        r.textAlignment = .center
        return r
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
            make.height.greaterThanOrEqualTo(747)
        }
        
        graphView.addSubview(graphLabel)
        graphLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(24)
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
            make.top.equalTo(graphVector.snp.bottom).offset(26)
            make.leading.equalTo(graphVector.snp.leading)
            make.centerX.equalTo(graphVector.snp.centerX)
            make.height.greaterThanOrEqualTo(270)
        }
        
        graphView.addSubview(rateLabel)
        rateLabel.snp.makeConstraints { make in
            make.top.equalTo(polygonChart.snp.bottom).offset(40)
            make.leading.equalTo(graphLabel)
        }
        
        graphView.addSubview(rateVector)
        rateVector.snp.makeConstraints { make in
            make.top.equalTo(rateLabel.snp.bottom).offset(6.06)
            make.leading.trailing.equalTo(graphVector)
            make.height.equalTo(1)
        }
        
        graphView.addSubview(ratingLabel)
        ratingLabel.snp.makeConstraints { make in
            make.leading.equalTo(rateVector.snp.leading).offset(6.5)
            make.top.equalTo(rateVector.snp.bottom).offset(11)
        }
        
        graphView.addSubview(ratingButton)
        ratingButton.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel.snp.top)
            make.leading.equalTo(ratingLabel.snp.trailing).offset(11.5)
            make.width.greaterThanOrEqualTo(114)
            make.height.greaterThanOrEqualTo(21)
        }
        
        graphView.addSubview(tastingNoteLabel)
        tastingNoteLabel.snp.makeConstraints { make in
            make.top.equalTo(ratingLabel).offset(38)
            make.leading.equalTo(ratingLabel.snp.leading)
        }
        
        graphView.addSubview(tastingNoteVector)
        tastingNoteVector.snp.makeConstraints { make in
            make.top.equalTo(tastingNoteLabel.snp.bottom).offset(6.06)
            make.leading.trailing.equalTo(rateVector)
            make.height.equalTo(1)
        }
        
        graphView.addSubview(aromaLabel)
        aromaLabel.snp.makeConstraints { make in
            make.top.equalTo(tastingNoteVector.snp.bottom).offset(12)
            make.leading.equalTo(tastingNoteVector.snp.leading).offset(7.94)
        }
        
        graphView.addSubview(aromaDescriptionLabel)
        aromaDescriptionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(aromaLabel.snp.centerY)
            make.leading.equalTo(aromaLabel.snp.trailing).offset(19.17)
        }
        
        graphView.addSubview(tasteLabel)
        tasteLabel.snp.makeConstraints { make in
            make.top.equalTo(aromaLabel.snp.bottom).offset(19)
            make.leading.equalTo(aromaLabel.snp.leading)
        }
        
        graphView.addSubview(tasteDescriptionLabel)
        tasteDescriptionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(tasteLabel.snp.centerY)
            make.leading.equalTo(aromaDescriptionLabel.snp.leading)
        }
        
        graphView.addSubview(finishLabel)
        finishLabel.snp.makeConstraints { make in
            make.top.equalTo(tasteLabel.snp.bottom).offset(19)
            make.leading.equalTo(tasteLabel.snp.leading)
        }
        
        graphView.addSubview(finishDescriptionLabel)
        finishDescriptionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(finishLabel.snp.centerY)
            make.leading.equalTo(tasteDescriptionLabel.snp.leading)
        }
        
        graphView.addSubview(reviewLabel)
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(finishLabel).offset(33)
            make.leading.equalTo(tastingNoteLabel)
        }
        
        graphView.addSubview(reviewVector)
        reviewVector.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(6.06)
            make.leading.trailing.equalTo(tastingNoteVector)
            make.height.equalTo(1)
        }
        
        graphView.addSubview(reviewDescription)
        reviewDescription.snp.makeConstraints { make in
            make.top.equalTo(reviewVector.snp.bottom).offset(22)
            make.leading.equalTo(reviewVector.snp.leading).offset(8.56)
        }
        
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(graphView.snp.bottom).offset(31)
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
