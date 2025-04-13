// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then

public class CustomStepSlider: UISlider {
    
    // MARK: - Properties
    private var stepValues: [Float] = [] // 스텝 값
    private let stepCounts = 5
    
    private var stepLabels: [String] = []
    private var stepLabelViews: [UILabel] = []
    
    // MARK: - Init
    public init(text1: String = "", text2: String = "", text3: String = "", text4: String = "", text5: String = "", step1: Float = 20, step2: Float = 40, step3: Float = 60, step4: Float = 80, step5: Float = 100) {
        super.init(frame: .zero)
        self.stepLabels = [text1, text2, text3, text4, text5]
        self.stepValues = [step1, step2, step3, step4, step5]
        setupUI()
        setupTrack()
        self.value = stepValues[2] // 기본값: 60
        if text1 == "" { setupCustomLabelThumb() } else { setupCustomThumb() }
        setupStepLabels()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let thumbRect = thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
        
        // 터치 범위를 Thumb 이미지 크기보다 위로 60pt 확장
        let largerThumbRect = thumbRect.inset(by: UIEdgeInsets(top: -200, left: -60, bottom: 0, right: -60))
        return largerThumbRect.contains(point)
    }
    
    // MARK: - Setup UI
    private let customThumbView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "thumbImage"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.zPosition = 1
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let thumbLabel = UILabel().then { label in
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.textColor = .white
    }
    
    private lazy var stepStackView = UIStackView().then { s in
        s.axis = .horizontal
        s.alignment = .center
        s.distribution = .equalSpacing
    }
    
    private func setupUI() {
        
        addSubview(customThumbView)
        addSubview(stepStackView)
        stepStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        for _ in 0..<stepCounts {
            let steps = createCircleView()
            steps.snp.makeConstraints { make in
                make.width.height.equalTo(8)
            }
            stepStackView.addArrangedSubview(steps)
        }
    }
    
    private func setupStepLabels() {
        for (index, labelText) in stepLabels.enumerated() {
            let label = UILabel()
            label.text = labelText
            label.font = UIFont.ptdRegularFont(ofSize: 12)
            label.textColor = AppColor.black
            label.textAlignment = .center
            stepLabelViews.append(label)
            addSubview(label)
            
            label.snp.makeConstraints { make in
                make.centerX.equalTo(stepStackView.arrangedSubviews[index].snp.centerX)
                make.top.equalTo(stepStackView.snp.bottom).offset(14)
            }
        }
    }
    
    private func setupCustomLabelThumb() {
        // 기존 Thumb 이미지 뷰 설정
        addSubview(customThumbView)
        customThumbView.addSubview(thumbLabel)
        
        // Thumb의 위치와 크기 설정
        updateThumbPosition(animated: false)
        
        // ThumbLabel의 위치와 크기 설정
        thumbLabel.snp.makeConstraints { make in
            make.bottom.equalTo(customThumbView.snp.bottom).inset(20)
            make.height.equalTo(customThumbView).inset(5) // Thumb 이미지 내부에 적절한 여백 추가
            make.leading.trailing.equalTo(customThumbView)
        }
        
        // PanGestureRecognizer 추가
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleThumbPan(_:)))
        customThumbView.addGestureRecognizer(panGesture)
    }
    
    private func setupCustomThumb() {
        // 기존 Thumb 이미지 뷰 설정
        addSubview(customThumbView)
        
        // Thumb의 위치와 크기 설정
        updateThumbPosition(animated: false)
        
        // PanGestureRecognizer 추가
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleThumbPan(_:)))
        customThumbView.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Create Circle View
    // 각 구간별 동그라미 생성
    private func createCircleView() -> UIView {
        let circleView = UIView()
        circleView.layer.cornerRadius = 4
        circleView.layer.borderWidth = 1
        circleView.layer.borderColor = AppColor.background.cgColor
        circleView.backgroundColor = AppColor.purple50
        return circleView
    }
    
    // MARK: - Setup Track
    public func setSavedValue(_ input: Double = 60) {
        switch input {
        case 20:
            value = stepValues[0]
        case 40:
            value = stepValues[1]
        case 60:
            value = stepValues[2]
        case 80:
            value = stepValues[3]
        default:
            value = stepValues[4]
        }
        updateThumbPosition(animated: false)
    }
    
    private func setupTrack() {
        self.minimumTrackTintColor = AppColor.purple30
        self.maximumTrackTintColor = AppColor.purple30
        
        let trackHeight: CGFloat = 2.0
        let trackImage = UIImage.createImage(withColor: AppColor.purple30!, size: CGSize(width: 1, height: trackHeight))
        self.setMinimumTrackImage(trackImage, for: .normal)
        self.setMaximumTrackImage(trackImage, for: .normal)
        
        minimumValue = stepValues.first ?? 20
        maximumValue = stepValues.last ?? 100
        
        setThumbImage(UIImage(), for: .normal)
        
        addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        addTarget(self, action: #selector(sliderDidEnded), for: [.touchUpInside, .touchUpOutside])
    }
    
    @objc private func handleThumbPan(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self)
        
        let trackRect = self.trackRect(forBounds: self.bounds)
        let sliderWidth = trackRect.width
        let newValue = minimumValue + Float((location.x - trackRect.minX) / sliderWidth) * (maximumValue - minimumValue)
        
        value = min(maximumValue, max(minimumValue, newValue))
        
        updateThumbPosition(animated: false)
        
        sendActions(for: .valueChanged)
    }
    
    private func updateThumbPosition(animated: Bool) {
        // ✅ 현재 value에 맞는 동그라미 뷰 가져오기
        let stepIndex = Int((value - minimumValue) / stepValues[0])
        guard stepIndex >= 0 && stepIndex < stepStackView.arrangedSubviews.count else { return }
        let targetCircleView = stepStackView.arrangedSubviews[stepIndex]
        
        // ✅ Thumb를 동그라미의 centerX에 맞춤
        guard let firstCircleView = stepStackView.arrangedSubviews.first else { return }
        
        let updateBlock = {
            self.customThumbView.snp.remakeConstraints { make in
                make.centerX.equalTo(targetCircleView.snp.centerX)
                make.bottom.equalTo(firstCircleView.snp.bottom).offset(8)
                make.width.equalTo(27)
                make.height.equalTo(62)
            }
            self.thumbLabel.text = "\(Int(self.value))" // Thumb Label의 텍스트 업데이트
            self.layoutIfNeeded()
        }
        
        if animated {
            UIView.animate(withDuration: 0.2, animations: updateBlock)
        } else {
            updateBlock()
        }
    }
    
    // MARK: - Slider Events
    @objc private func sliderValueChanged() {
        snapToStep()
        updateThumbPosition(animated: false)
    }
    
    @objc private func sliderDidEnded() {
        snapToStep()
        updateThumbPosition(animated: true)
    }
    
    // MARK: - Snap to Nearest Step
    private func snapToStep() {
        let closestValue = stepValues.min(by: { abs($0 - value) < abs($1 - value) }) ?? value
        value = closestValue
    }
}

extension UIImage {
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
