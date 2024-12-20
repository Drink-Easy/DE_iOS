//
//  RecordGraphView.swift
//  Drink-EG
//
//  Created by 이수현 on 11/18/24.
//

import UIKit

class RecordGraphView: UIView {

    
    let wineNameLabel: UILabel = {
        let w = UILabel()
        w.text = "루이 로드레 크리스탈 2015"
        w.font = .ptdSemiBoldFont(ofSize: 24)
        w.textColor = .black
        w.textAlignment = .center
        return w
    }()
    
    let wineImage: UIImageView = {
        let w = UIImageView()
        w.layer.cornerRadius = 14
        w.contentMode = .scaleAspectFit
        w.image = UIImage(named: "루이로드레")
        return w
    }()
    
    let descriptionView: DescriptionUIView = {
        let d = DescriptionUIView()
        d.layer.cornerRadius = 14
        d.backgroundColor = .white
        return d
    }()
    
    let graphView: UIView = {
        let g = UIView()
        g.backgroundColor = .white
        g.layer.cornerRadius = 24
        g.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        return g
    }()
    
    let graphLabel: UILabel = {
        let g = UILabel()
        g.text = "Graph"
        g.textColor = .black
        g.textAlignment = .center
        g.font = .ptdSemiBoldFont(ofSize: 20)
        return g
    }()
    
    let graphLabelKorean: UILabel = {
        let g = UILabel()
        g.text = "그래프"
        g.textColor = UIColor(hex: "919191")
        g.textAlignment = .center
        g.font = .ptdRegularFont(ofSize: 14)
        return g
    }()
    
    let vector: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#B06FCD")
        return v
    }()
    
    let polygonChart: PolygonChartView = {
        let p = PolygonChartView()
        return p
    }()
    
    let recordGraphView: UIView = {
        let r = UIView()
        r.backgroundColor = .white
        r.layer.cornerRadius = 24
        r.layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
        r.layer.borderWidth = 1
        r.layer.borderColor = UIColor.black.cgColor
        return r
    }()
    
    let graphRecordLabel: UILabel = {
        let g = UILabel()
        g.text = "Graph Record"
        g.textColor = .black
        g.textAlignment = .center
        g.font = .ptdSemiBoldFont(ofSize: 20)
        return g
    }()
    
    let graphRecordLabelKorean: UILabel = {
        let g = UILabel()
        g.text = "그래프 상세기록"
        g.textColor = UIColor(hex: "919191")
        g.textAlignment = .center
        g.font = .ptdRegularFont(ofSize: 14)
        return g
    }()
    
    let vector2: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(hex: "#B06FCD")
        return v
    }()
    
    let sweetnessLabel: UILabel = {
        let s = UILabel()
        s.text = "당도"
        s.textColor = .black
        s.textAlignment = .center
        s.font = .ptdMediumFont(ofSize: 18)
        return s
    }()
    
    
    
    
    
    func setupUI() {
        addSubview(wineNameLabel)
        wineNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(110)
            make.leading.equalToSuperview().offset(24)
        }
        
        addSubview(wineImage)
        wineImage.snp.makeConstraints { make in
            make.top.equalTo(wineNameLabel.snp.bottom).offset(20)
            make.leading.equalTo(wineNameLabel.snp.leading)
        }
        
        addSubview(descriptionView)
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(wineImage)
            make.leading.equalTo(wineImage.snp.trailing).offset(8)
        }
        
        addSubview(graphView)
        graphView.snp.makeConstraints { make in
            make.top.equalTo(wineImage.snp.bottom).offset(36)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(911)
        }
        
        graphView.addSubview(graphLabel)
        graphLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(24)
            make.width.equalTo(57)
        }
        
        graphView.addSubview(graphLabelKorean)
        graphLabelKorean.snp.makeConstraints { make in
            make.top.equalTo(graphLabel.snp.top).offset(4)
            make.leading.equalTo(graphLabel.snp.trailing).offset(8)
        }
        
        graphView.addSubview(vector)
        vector.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(graphLabel.snp.bottom).offset(6)
            make.leading.equalTo(graphLabel.snp.leading)
            make.centerX.equalToSuperview()
        }
        
        graphView.addSubview(polygonChart)
        polygonChart.snp.makeConstraints { make in
            make.top.equalTo(vector.snp.bottom).offset(25)
            make.leading.equalTo(vector.snp.leading).offset(17)
            make.centerX.equalTo(vector.snp.centerX)
            make.height.equalTo(311)
        }
        
        graphView.addSubview(recordGraphView)
        recordGraphView.snp.makeConstraints { make in
            make.top.equalTo(polygonChart.snp.bottom).offset(65)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(561)
        }
        
        recordGraphView.addSubview(graphRecordLabel)
        graphRecordLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(25)
        }
        
        recordGraphView.addSubview(graphRecordLabelKorean)
        graphRecordLabelKorean.snp.makeConstraints { make in
            make.top.equalTo(graphRecordLabel.snp.top).offset(4)
            make.leading.equalTo(graphRecordLabel.snp.trailing).offset(6)
        }
        
        recordGraphView.addSubview(vector2)
        vector2.snp.makeConstraints { make in
            make.top.equalTo(graphRecordLabel.snp.bottom).offset(6)
            make.leading.equalTo(graphRecordLabel)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        
        
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(hex: "#F8F8FA")
        setupUI()
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
