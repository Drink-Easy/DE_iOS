// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

public class CustomSlider: UISlider {
    
    public var dividers: [UIView] = []
    public let stepValues: [Float] = [20, 40, 60, 80, 100]
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSlider()
    }
    
    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupSlider() {
        minimumTrackTintColor = AppColor.purple20
        maximumTrackTintColor = AppColor.purple20
        
        setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
        
        minimumValue = stepValues.first ?? 20 // 최소값
        maximumValue = stepValues.last ?? 100 // 최대값
        value = stepValues[2]
        
        updateThumbImage()
        
        addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        addTarget(self, action: #selector(sliderDidEnded), for: [.touchUpInside, .touchUpOutside])
    }
    
    public override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        // 기존 UISlider의 Thumb 위치 계산
        let originalThumbRect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        
        let yOffset: CGFloat = -19
        
        return originalThumbRect.offsetBy(dx: 0, dy: yOffset)
    }
    
    @objc public func sliderValueChanged() {
        snapToStep()
    }
    
    @objc public func sliderDidEnded() {
        snapToStep()
        updateThumbImage()
    }
    
    public func snapToStep() {
        let closestValue = stepValues.min(by: { abs($0 - value) < abs($1 - value) }) ?? value
        value = closestValue
    }
    
    public func updateThumbImage() {
        // 현재 슬라이더 값에 해당하는 텍스트 생성
        let text = "\(Int(value))"
        
        // 기존 Thumb 이미지를 로드
        guard let baseImage = UIImage(named: "sliderThumb") else {
            print("Thumb base image not found")
            return
        }
        
        // Thumb 이미지 위에 텍스트 추가
        let renderer = UIGraphicsImageRenderer(size: baseImage.size)
        let thumbImageWithText = renderer.image { context in
            // 원래 Thumb 이미지 그리기
            baseImage.draw(at: .zero)
            
            // 텍스트 그리기
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 14),
                .foregroundColor: UIColor.white
            ]
            let textSize = text.size(withAttributes: attributes)
            let textRect = CGRect(
                x: (baseImage.size.width - textSize.width) / 2,
                y: (baseImage.size.height - textSize.height) / 2 - 10,
                width: textSize.width,
                height: textSize.height
            )
            text.draw(in: textRect, withAttributes: attributes)
        }
        
        // Thumb에 이미지 설정
        setThumbImage(thumbImageWithText, for: .normal)
    }
}
