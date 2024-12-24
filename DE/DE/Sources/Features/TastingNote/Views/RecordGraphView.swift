//
//  RecordGraphView.swift
//  Drink-EG
//
//  Created by 이수현 on 11/18/24.
//

import UIKit
import CoreModule

class RecordGraphView: UIView {

    let scrollView: UIScrollView = {
        let s = UIScrollView()
        return s
    }()
    
    let contentView: UIView = {
        let c = UIView()
        c.backgroundColor = AppColor.gray20
        return c
    }()
    
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
    
    let sweetToolTip: UIButton = {
        let s = UIButton()
        s.setImage(UIImage(systemName: "info.circle"), for: .normal)
        s.tintColor = AppColor.gray60
        return s
    }()
    
    let sweetSlider: CustomSlider = {
        let c = CustomSlider()
        return c
    }()
    
    let acidLabel: UILabel = {
        let s = UILabel()
        s.text = "산도"
        s.textColor = .black
        s.textAlignment = .center
        s.font = .ptdMediumFont(ofSize: 18)
        return s
    }()
    
    let acidToolTip: UIButton = {
        let s = UIButton()
        s.setImage(UIImage(systemName: "info.circle"), for: .normal)
        s.tintColor = AppColor.gray60
        return s
    }()
    
    let acidSlider: CustomSlider = {
        let c = CustomSlider()
        return c
    }()
    
    func setupUI() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        contentView.addSubview(wineNameLabel)
        wineNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(110)
            make.leading.equalToSuperview().offset(24)
        }
        
        contentView.addSubview(wineImage)
        wineImage.snp.makeConstraints { make in
            make.top.equalTo(wineNameLabel.snp.bottom).offset(20)
            make.leading.equalTo(wineNameLabel.snp.leading)
        }
        
        contentView.addSubview(graphView)
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
        
        recordGraphView.addSubview(sweetnessLabel)
        sweetnessLabel.snp.makeConstraints { make in
            make.top.equalTo(vector2.snp.bottom).offset(58)
            make.leading.equalTo(vector2.snp.leading)
        }
        
        recordGraphView.addSubview(sweetToolTip)
        sweetToolTip.snp.makeConstraints { make in
            make.top.equalTo(sweetnessLabel).offset(6)
            make.centerY.equalTo(sweetnessLabel)
            make.leading.equalTo(sweetnessLabel.snp.trailing).offset(4)
        }
        
        recordGraphView.addSubview(sweetSlider)
        sweetSlider.snp.makeConstraints { make in
            make.top.equalTo(sweetToolTip.snp.top).offset(3)
            make.leading.equalTo(sweetToolTip.snp.trailing).offset(23)
            make.centerY.equalTo(sweetToolTip.snp.centerY)
            make.trailing.equalTo(vector2.snp.trailing)
        }
        
        recordGraphView.addSubview(acidLabel)
        acidLabel.snp.makeConstraints { make in
            make.top.equalTo(sweetnessLabel.snp.bottom).offset(46)
            make.leading.equalTo(sweetnessLabel.snp.leading)
        }
        
        recordGraphView.addSubview(acidToolTip)
        acidToolTip.snp.makeConstraints { make in
            make.top.equalTo(acidLabel).offset(6)
            make.centerY.equalTo(acidLabel)
            make.leading.equalTo(acidLabel.snp.trailing).offset(4)
        }
        
        recordGraphView.addSubview(acidSlider)
        acidSlider.snp.makeConstraints { make in
            make.top.equalTo(acidToolTip.snp.top).offset(3)
            make.leading.equalTo(acidToolTip.snp.trailing).offset(23)
            make.centerY.equalTo(acidToolTip.snp.centerY)
            make.trailing.equalTo(sweetSlider.snp.trailing)
        }
        
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(recordGraphView.snp.bottom).offset(20)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColor.gray20
        setupUI()
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
