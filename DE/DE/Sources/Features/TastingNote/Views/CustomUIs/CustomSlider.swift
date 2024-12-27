// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

class CustomSlider: UISlider {
    
    private var dividers: [UIView] = []
    private let stepValues: [Float] = [20, 40, 60, 80, 100]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSlider()
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSlider() {
        minimumTrackTintColor = AppColor.purple20
        maximumTrackTintColor = AppColor.purple20
        
        setThumbImage(UIImage(named: "thumb"), for: .normal)
        
        minimumValue = stepValues.first ?? 20 // 최소값
        maximumValue = stepValues.last ?? 100 // 최대값
        value = stepValues[2]
        
        addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        addTarget(self, action: #selector(sliderDidEnded), for: [.touchUpInside, .touchUpOutside])
    }
    
    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        // 기존 UISlider의 Thumb 위치 계산
        let originalThumbRect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        
        // Thumb의 Y축 위치를 올림 (현재 위치에서 10포인트 위로)
        let yOffset: CGFloat = -18 // 원하는 만큼 올릴 수 있음
        
        return originalThumbRect.offsetBy(dx: 0, dy: yOffset)
    }
    
    @objc private func sliderValueChanged() {
        snapToStep()
    }
    
    @objc private func sliderDidEnded() {
        snapToStep()
    }
    
    private func snapToStep() {
        let closestValue = stepValues.min(by: { abs($0 - value) < abs($1 - value) }) ?? value
        value = closestValue
    }
}
