// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import AMPopTip
import Network

class ChangeGraphView: UIView, UIScrollViewDelegate {
    
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
        s.tag = 0
        return s
    }()
    
    let sweetTip: PopTip = {
        let s = PopTip()
        s.bubbleColor = AppColor.gray100 ?? UIColor(hex: "#121212B3")!
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
        s.tag = 1
        return s
    }()
    
    let acidTip: PopTip = {
        let s = PopTip()
        s.bubbleColor = AppColor.gray100 ?? UIColor(hex: "#121212B3")!
        return s
    }()
    
    let acidSlider: CustomSlider = {
        let c = CustomSlider()
        return c
    }()
    
    let tanninLabel: UILabel = {
        let s = UILabel()
        s.text = "타닌"
        s.textColor = .black
        s.textAlignment = .center
        s.font = .ptdMediumFont(ofSize: 18)
        return s
    }()
    
    let tanninToolTip: UIButton = {
        let s = UIButton()
        s.setImage(UIImage(systemName: "info.circle"), for: .normal)
        s.tintColor = AppColor.gray60
        s.tag = 2
        return s
    }()
    
    let tanninTip: PopTip = {
        let s = PopTip()
        s.bubbleColor = AppColor.gray100 ?? UIColor(hex: "#121212B3")!
        return s
    }()
    
    let tanninSlider: CustomSlider = {
        let c = CustomSlider()
        return c
    }()
    
    let bodyLabel: UILabel = {
        let s = UILabel()
        s.text = "바디"
        s.textColor = .black
        s.textAlignment = .center
        s.font = .ptdMediumFont(ofSize: 18)
        return s
    }()
    
    let bodyToolTip: UIButton = {
        let s = UIButton()
        s.setImage(UIImage(systemName: "info.circle"), for: .normal)
        s.tintColor = AppColor.gray60
        s.tag = 3
        return s
    }()
    
    let bodyTip: PopTip = {
        let s = PopTip()
        s.bubbleColor = AppColor.gray100 ?? UIColor(hex: "#121212B3")!
        return s
    }()
    
    let bodySlider: CustomSlider = {
        let c = CustomSlider()
        return c
    }()
    
    let alcoholLabel: UILabel = {
        let s = UILabel()
        s.text = "알코올"
        s.textColor = .black
        s.textAlignment = .center
        s.font = .ptdMediumFont(ofSize: 18)
        return s
    }()
    
    let alcoholToolTip: UIButton = {
        let s = UIButton()
        s.setImage(UIImage(systemName: "info.circle"), for: .normal)
        s.tintColor = AppColor.gray60
        s.tag = 4
        return s
    }()
    
    let alcoholTip: PopTip = {
        let s = PopTip()
        s.bubbleColor = AppColor.gray100 ?? UIColor(hex: "#121212B3")!
        return s
    }()
    
    let alcoholSlider: CustomSlider = {
        let c = CustomSlider()
        return c
    }()
    
    let nextButton: UIButton = {
        let n = UIButton()
        n.setTitle("저장하기", for: .normal)
        n.titleLabel?.font = .ptdBoldFont(ofSize: 18)
        n.setTitleColor(.white, for: .normal)
        n.backgroundColor = AppColor.purple100
        n.layer.cornerRadius = 14
        return n
    }()
    
    func updateUI(dto: TastingNoteResponsesDTO) {
        wineNameLabel.text = dto.wineName
        sweetSlider.value = Float(dto.sugarContent)
        acidSlider.value = Float(dto.acidity)
        tanninSlider.value = Float(dto.tannin)
        bodySlider.value = Float(dto.body)
        alcoholSlider.value = Float(dto.alcohol)
    }
    
    func setupUI() {
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
        
        contentView.addSubview(wineNameLabel)
        wineNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(24)
        }
        
        contentView.addSubview(wineImage)
        wineImage.snp.makeConstraints { make in
            make.top.equalTo(wineNameLabel.snp.bottom).offset(20)
            make.leading.equalTo(wineNameLabel.snp.leading)
        }
        
        contentView.addSubview(graphLabel)
        graphLabel.snp.makeConstraints { make in
            make.top.equalTo(wineNameLabel.snp.bottom).offset(38)
            make.leading.equalToSuperview().offset(24)
            make.width.equalTo(57)
        }
        
        contentView.addSubview(graphLabelKorean)
        graphLabelKorean.snp.makeConstraints { make in
            make.top.equalTo(graphLabel.snp.top).offset(4)
            make.leading.equalTo(graphLabel.snp.trailing).offset(8)
        }
        
        contentView.addSubview(vector)
        vector.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(graphLabel.snp.bottom).offset(6)
            make.leading.equalTo(graphLabel.snp.leading)
            make.centerX.equalToSuperview()
        }
        
        contentView.addSubview(polygonChart)
        polygonChart.snp.makeConstraints { make in
            make.top.equalTo(vector.snp.bottom).offset(25)
            make.leading.equalTo(vector.snp.leading).offset(17)
            make.centerX.equalTo(vector.snp.centerX)
            make.height.equalTo(311)
        }
        
        contentView.addSubview(graphRecordLabel)
        graphRecordLabel.snp.makeConstraints { make in
            make.top.equalTo(polygonChart.snp.bottom).offset(57)
            make.leading.equalTo(graphLabel.snp.leading)
        }
        
        contentView.addSubview(graphRecordLabelKorean)
        graphRecordLabelKorean.snp.makeConstraints { make in
            make.top.equalTo(graphRecordLabel.snp.top).offset(4)
            make.leading.equalTo(graphRecordLabel.snp.trailing).offset(6)
        }
        
        contentView.addSubview(vector2)
        vector2.snp.makeConstraints { make in
            make.top.equalTo(graphRecordLabel.snp.bottom).offset(6)
            make.leading.equalTo(graphRecordLabel)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        
        contentView.addSubview(sweetnessLabel)
        sweetnessLabel.snp.makeConstraints { make in
            make.top.equalTo(vector2.snp.bottom).offset(58)
            make.leading.equalTo(vector2.snp.leading)
        }
        
        contentView.addSubview(sweetToolTip)
        sweetToolTip.snp.makeConstraints { make in
            make.top.equalTo(sweetnessLabel).offset(6)
            make.centerY.equalTo(sweetnessLabel)
            make.leading.equalTo(sweetnessLabel.snp.trailing).offset(4)
        }
        
        contentView.addSubview(sweetSlider)
        sweetSlider.snp.makeConstraints { make in
            make.top.equalTo(sweetToolTip.snp.top).offset(3)
            make.leading.equalTo(sweetToolTip.snp.trailing).offset(23)
            make.centerY.equalTo(sweetToolTip.snp.centerY)
            make.trailing.equalTo(vector2.snp.trailing)
        }
        
        contentView.addSubview(acidLabel)
        acidLabel.snp.makeConstraints { make in
            make.top.equalTo(sweetnessLabel.snp.bottom).offset(46)
            make.leading.equalTo(sweetnessLabel.snp.leading)
        }
        
        contentView.addSubview(acidToolTip)
        acidToolTip.snp.makeConstraints { make in
            make.top.equalTo(acidLabel).offset(6)
            make.centerY.equalTo(acidLabel)
            make.leading.equalTo(acidLabel.snp.trailing).offset(4)
        }
        
        contentView.addSubview(acidSlider)
        acidSlider.snp.makeConstraints { make in
            make.top.equalTo(acidToolTip.snp.top).offset(3)
            make.leading.trailing.equalTo(sweetSlider)
            make.centerY.equalTo(acidToolTip.snp.centerY)
            make.trailing.equalTo(sweetSlider.snp.trailing)
        }
        
        contentView.addSubview(tanninLabel)
        tanninLabel.snp.makeConstraints { make in
            make.top.equalTo(acidLabel.snp.bottom).offset(46)
            make.leading.equalTo(acidLabel.snp.leading)
        }
        
        contentView.addSubview(tanninToolTip)
        tanninToolTip.snp.makeConstraints { make in
            make.top.equalTo(tanninLabel).offset(6)
            make.centerY.equalTo(tanninLabel)
            make.leading.equalTo(tanninLabel.snp.trailing).offset(4)
        }
        
        contentView.addSubview(tanninSlider)
        tanninSlider.snp.makeConstraints { make in
            make.top.equalTo(tanninToolTip.snp.top).offset(3)
            make.leading.trailing.equalTo(acidSlider)
            make.centerY.equalTo(tanninToolTip.snp.centerY)
            make.trailing.equalTo(acidSlider.snp.trailing)
        }
        
        contentView.addSubview(bodyLabel)
        bodyLabel.snp.makeConstraints { make in
            make.top.equalTo(tanninLabel.snp.bottom).offset(46)
            make.leading.equalTo(tanninLabel.snp.leading)
        }
        
        contentView.addSubview(bodyToolTip)
        bodyToolTip.snp.makeConstraints { make in
            make.top.equalTo(bodyLabel).offset(6)
            make.centerY.equalTo(bodyLabel)
            make.leading.equalTo(bodyLabel.snp.trailing).offset(4)
        }
        
        contentView.addSubview(bodySlider)
        bodySlider.snp.makeConstraints { make in
            make.top.equalTo(bodyToolTip.snp.top).offset(3)
            make.leading.trailing.equalTo(tanninSlider)
            make.centerY.equalTo(bodyToolTip.snp.centerY)
            make.trailing.equalTo(tanninSlider.snp.trailing)
        }
        
        contentView.addSubview(alcoholLabel)
        alcoholLabel.snp.makeConstraints { make in
            make.top.equalTo(bodyLabel.snp.bottom).offset(46)
            make.leading.equalTo(bodyLabel.snp.leading)
        }
        
        contentView.addSubview(alcoholToolTip)
        alcoholToolTip.snp.makeConstraints { make in
            make.top.equalTo(alcoholLabel).offset(6)
            make.centerY.equalTo(alcoholLabel)
            make.leading.equalTo(alcoholLabel.snp.trailing).offset(4)
        }
        
        contentView.addSubview(alcoholSlider)
        alcoholSlider.snp.makeConstraints { make in
            make.top.equalTo(alcoholToolTip.snp.top).offset(3)
            make.leading.trailing.equalTo(bodySlider)
            make.centerY.equalTo(alcoholToolTip.snp.centerY)
            make.trailing.equalTo(bodySlider.snp.trailing)
        }
        
        contentView.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(alcoholLabel.snp.bottom).offset(54)
            make.leading.equalTo(vector2.snp.leading).offset(4)
            make.centerX.equalTo(vector2.snp.centerX)
            make.height.greaterThanOrEqualTo(56)
        }
        
        contentView.snp.makeConstraints { make in
            make.bottom.equalTo(nextButton.snp.bottom).offset(34)
        }
    }
    
    func setupActions() {
        sweetToolTip.addTarget(self, action: #selector(popupTips), for: .touchUpInside)
        acidToolTip.addTarget(self, action: #selector(popupTips), for: .touchUpInside)
        tanninToolTip.addTarget(self, action: #selector(popupTips), for: .touchUpInside)
        bodyToolTip.addTarget(self, action: #selector(popupTips), for: .touchUpInside)
        alcoholToolTip.addTarget(self, action: #selector(popupTips), for: .touchUpInside)
    }
    
    @objc func popupTips(_ sender: UIButton) {
        guard let buttonSuperview = sender.superview else { return }
        
        let buttonFrameInScrollView = buttonSuperview.convert(sender.frame, to: scrollView)
        
        let selectedTip: PopTip
        let text: String
        switch sender.tag {
        case 0:
            selectedTip = sweetTip
            text = "와인이 달콤하면 당도가 높고, 달지 않으면 드라이(dry)한 와인이라고 해요. 혀끝에서 단 맛이 나는지 느껴보세요!"
        case 1:
            selectedTip = acidTip
            text = "산도가 높은 와인은 입 안이 상쾌해지고 신선한 느낌이 들어요. 산도가 낮으면 좀 더 부드럽고 묵직한 느낌이에요."
        case 2:
            selectedTip = tanninTip
            text = "주로 레드 와인에서 느껴지는 성분이에요. 타닌이 많을수록 입안이 살짝 뻑뻑한 느낌이 들어요. 타닌이 적으면 더 부드럽게 넘어갑니다."
        case 3:
            selectedTip = bodyTip
            text = "와인이 가볍게 느껴지나요, 아니면 묵직하고 풍부한 느낌인가요? 입 안에 느껴지는 점도를 뜻 한답니다!"
        case 4:
            selectedTip = alcoholTip
            text = "알코올이 많으면 목을 넘어갈 때 따뜻하거나 약간 뜨거운 느낌이 나요. 적으면 더 부드럽고 가벼운 느낌이랍니다."
        default:
            return
        }
        
        selectedTip.bubbleColor = AppColor.gray100 ?? UIColor(hex: "#121212B3")!
        selectedTip.show(
            text: text,
            direction: .down,
            maxWidth: 200,
            in: scrollView,
            from: buttonFrameInScrollView
        )
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColor.gray20
        setupUI()
        setupActions()
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
