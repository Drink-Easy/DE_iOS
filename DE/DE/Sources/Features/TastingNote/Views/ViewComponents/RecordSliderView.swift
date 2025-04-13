// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import AMPopTip

// 와인 당도 등등 슬라이더 설정
class RecordSliderView: UIView {
    
    public lazy var propertyHeader = PropertyTitleView(type: .none)
    
    let sweetnessView = SliderWithTooltipView()
    let acidityView = SliderWithTooltipView()
    let tanninView = SliderWithTooltipView()
    let bodyView = SliderWithTooltipView()
    let alcoholView = SliderWithTooltipView()
    

    func setupUI() {
        [propertyHeader, sweetnessView, acidityView, tanninView, bodyView, alcoholView].forEach {
            addSubview($0)
        }
        
        sweetnessView.titleLabel.text = "당도"
        sweetnessView.tooltipText = "와인이 달콤하면 당도가 높고, 달지 않으면 드라이(dry)한 와인이라고 해요. 혀끝에서 단 맛이 나는지 느껴보세요!"
        acidityView.titleLabel.text = "산도"
        acidityView.tooltipText = "산도가 높은 와인은 입 안이 상쾌해지고 신선한 느낌이 들어요. 산도가 낮으면 좀 더 부드럽고 묵직한 느낌이에요."
        tanninView.titleLabel.text = "타닌"
        tanninView.tooltipText = "주로 레드 와인에서 느껴지는 성분이에요. 타닌이 많을수록 입안이 살짝 뻑뻑한 느낌이 들어요. 타닌이 적으면 더 부드럽게 넘어갑니다."
        bodyView.titleLabel.text = "바디"
        bodyView.tooltipText = "와인이 가볍게 느껴지나요, 아니면 묵직하고 풍부한 느낌인가요? 입 안에 느껴지는 점도를 뜻 한답니다!"
        alcoholView.titleLabel.text = "알코올"
        alcoholView.tooltipText = "알코올이 많으면 목을 넘어갈 때 따뜻하거나 약간 뜨거운 느낌이 나요. 적으면 더 부드럽고 가벼운 느낌이랍니다."
        
        propertyHeader.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(30)
        }
        
        sweetnessView.snp.makeConstraints { make in
            make.top.equalTo(propertyHeader.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(70)
        }
        alcoholView.snp.makeConstraints { make in
            make.top.equalTo(sweetnessView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(70)
        }
        tanninView.snp.makeConstraints { make in
            make.top.equalTo(alcoholView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(70)
        }
        bodyView.snp.makeConstraints { make in
            make.top.equalTo(tanninView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(70)
        }
        acidityView.snp.makeConstraints { make in
            make.top.equalTo(bodyView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(70)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColor.background
        setupUI()
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
