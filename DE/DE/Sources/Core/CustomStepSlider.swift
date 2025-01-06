// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

public class CustomStepSlider: UISlider {
    
    private let stepValues: [Float] = [20, 40, 60, 80, 100] // 스텝 값
        private var labels: [UILabel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupThumb()
        setupUI()
        setupTrack()
        // moveThumbUp()
    }
    
    // setupThumb 메서드를 통해 썸 이미지를 설정합니다.
    private func setupThumb() {
        if let thumbImage = UIImage(named: "thumbImage") {
            self.setThumbImage(thumbImage, for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let firstStep: UIView = {
        let f = UIView()
        f.backgroundColor = UIColor(hex: "F8F8FA")
        f.layer.cornerRadius = 4
        let circleView = UIView()
        f.addSubview(circleView)
        circleView.backgroundColor = AppColor.purple50
        circleView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(1)
        }
        circleView.layer.cornerRadius = 3
        return f
    }()
    
    private let secondStep: UIView = {
        let f = UIView()
        f.backgroundColor = UIColor(hex: "F8F8FA")
        f.layer.cornerRadius = 4
        let circleView = UIView()
        f.addSubview(circleView)
        circleView.backgroundColor = AppColor.purple50
        circleView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(1)
        }
        circleView.layer.cornerRadius = 3
        return f
    }()
    
    private let thirdStep: UIView = {
        let f = UIView()
        f.backgroundColor = UIColor(hex: "F8F8FA")
        f.layer.cornerRadius = 4
        let circleView = UIView()
        f.addSubview(circleView)
        circleView.backgroundColor = AppColor.purple50
        circleView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(1)
        }
        circleView.layer.cornerRadius = 3
        return f
    }()
    
    private let fourthStep: UIView = {
        let f = UIView()
        f.backgroundColor = UIColor(hex: "F8F8FA")
        f.layer.cornerRadius = 4
        let circleView = UIView()
        f.addSubview(circleView)
        circleView.backgroundColor = AppColor.purple50
        circleView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(1)
        }
        circleView.layer.cornerRadius = 3
        return f
    }()
    
    private let fifthStep: UIView = {
        let f = UIView()
        f.backgroundColor = UIColor(hex: "F8F8FA")
        f.layer.cornerRadius = 4
        let circleView = UIView()
        f.addSubview(circleView)
        circleView.backgroundColor = AppColor.purple50
        circleView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(1)
        }
        circleView.layer.cornerRadius = 3
        return f
    }()
    
    private let blind1: UIView = {
        let b = UIView()
        b.backgroundColor = UIColor(hex: "F8F8FA")
        return b
    }()
    
    private let blind2: UIView = {
        let b = UIView()
        b.backgroundColor = UIColor(hex: "F8F8FA")
        return b
    }()
    
    private func setupTrack() {
        // 트랙 색상 변경
        self.minimumTrackTintColor = AppColor.purple30
        self.maximumTrackTintColor = AppColor.purple30
        
        // 트랙 크기 변경 (이미지를 사용하여 커스터마이즈)
        let trackHeight: CGFloat = 2.0
        let trackImage = UIImage.createImage(withColor: AppColor.purple30!, size: CGSize(width: 1, height: trackHeight))
        
        // 트랙 이미지를 최소값, 최대값 트랙에 설정
        self.setMinimumTrackImage(trackImage, for: .normal)
        self.setMaximumTrackImage(trackImage, for: .normal)
        
        minimumValue = stepValues.first ?? 20 // 최소값
        maximumValue = stepValues.last ?? 100 // 최대값
        value = stepValues[2]
        
        updateThumbImage()
        
        addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        addTarget(self, action: #selector(sliderDidEnded), for: [.touchUpInside, .touchUpOutside])
    }
    
    @objc private func sliderValueChanged() {
        snapToStep()
    }
    
    @objc private func sliderDidEnded() {
        snapToStep()
        updateThumbImage()
    }
    
    private func snapToStep() {
        let closestValue = stepValues.min(by: { abs($0 - value) < abs($1 - value) }) ?? value
        value = closestValue
    }
    
    private func updateThumbImage() {
        // 현재 슬라이더 값에 해당하는 텍스트 생성
        let text = "\(Int(value))"
        
        // 기존 Thumb 이미지를 로드
        guard let baseImage = UIImage(named: "thumbImage") else {
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
    
    public override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        // 기존 UISlider의 Thumb 위치 계산
        let originalThumbRect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        
        // thumb의 높이 절반만큼 위로 이동
        let thumbHeight = originalThumbRect.size.height
        let yOffset = -thumbHeight * 0.32
        
        // 수정된 Thumb 위치 반환
        return originalThumbRect.offsetBy(dx: 0, dy: yOffset)
    }
    
    func setupUI() {
        addSubview(firstStep)
        firstStep.snp.makeConstraints { make in
            // make.top.equalToSuperview().offset(1)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(7)
            make.width.height.equalTo(8)
        }
        
        addSubview(blind1)
        blind1.snp.makeConstraints { make in
            make.top.equalTo(firstStep.snp.top).offset(4)
            make.leading.equalToSuperview()
            make.trailing.equalTo(firstStep.snp.leading)
            make.height.equalTo(2)
        }
        
        addSubview(fifthStep)
        fifthStep.snp.makeConstraints { make in
            // make.top.equalToSuperview().offset(1)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-7)
            make.width.height.equalTo(8)
        }
        
        addSubview(blind2)
        blind2.snp.makeConstraints { make in
            make.top.equalTo(firstStep.snp.top).offset(4)
            make.trailing.equalToSuperview()
            make.leading.equalTo(fifthStep.snp.trailing)
            make.height.equalTo(2)
        }
        
        addSubview(thirdStep)
        thirdStep.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(firstStep)
            make.height.width.equalTo(8)
        }
        
        addSubview(secondStep)
        secondStep.snp.makeConstraints { make in
            make.centerY.equalTo(firstStep.snp.centerY)
            make.leading.equalTo(firstStep.snp.trailing).offset(54)
            make.width.height.equalTo(8)
        }
        
        addSubview(fourthStep)
        fourthStep.snp.makeConstraints { make in
            make.centerY.equalTo(firstStep.snp.centerY)
            make.leading.equalTo(thirdStep.snp.trailing).offset(53)
            make.width.height.equalTo(8)
        }
    }
    
}

extension UIImage {
    // 색상으로 이미지를 생성하는 메서드
    static func createImage(withColor color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        color.setFill()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}
