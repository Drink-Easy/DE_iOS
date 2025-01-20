// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit

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
        setupCustomThumb()
        setupStepLabels()
        // setInitialValue()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Thumb Image
    private let customThumbView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "thumbImage"))
        imageView.contentMode = .scaleAspectFit
        imageView.layer.zPosition = 1
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let thumbRect = thumbRect(forBounds: bounds, trackRect: trackRect(forBounds: bounds), value: value)
        
        // 터치 범위를 Thumb 이미지 크기보다 위로 60pt 확장
        let largerThumbRect = thumbRect.inset(by: UIEdgeInsets(top: -60, left: -60, bottom: 0, right: -60))
        return largerThumbRect.contains(point)
    }
    
    // MARK: - Setup UI
    private lazy var stepStackView: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.alignment = .center
        s.distribution = .equalSpacing
        return s
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
    
    private func setupUI() {
        addSubview(blind1)
        blind1.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalTo(8)
            make.bottom.top.equalToSuperview()
        }
        
        addSubview(blind2)
        blind2.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.width.equalTo(8)
            make.bottom.top.equalToSuperview()
        }
        
        addSubview(customThumbView)
        addSubview(stepStackView)
        stepStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.height.equalTo(8)
        }
        
        for _ in 0..<stepCounts {
            let steps = createCircleView()
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
    
    private func setupCustomThumb() {
        addSubview(customThumbView)
        updateThumbPosition(animated: false)
        
        // ✅ PanGestureRecognizer 추가
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleThumbPan(_:)))
        customThumbView.addGestureRecognizer(panGesture)
    }
    
    // MARK: - Create Circle View
    private func createCircleView() -> UIView {
        let circleView = UIView()
        circleView.layer.cornerRadius = 4
        circleView.backgroundColor = UIColor(hex: "F8F8FA")
        circleView.snp.makeConstraints { make in
            make.width.height.equalTo(8)
        }
        
        let innerCircle = UIView()
        innerCircle.layer.cornerRadius = 3
        innerCircle.backgroundColor = AppColor.purple50
        circleView.addSubview(innerCircle)
        innerCircle.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(1)
            make.width.height.equalTo(6)
        }
        
        return circleView
    }
    
    // MARK: - Setup Track
    private func setupTrack() {
        self.minimumTrackTintColor = AppColor.purple30
        self.maximumTrackTintColor = AppColor.purple30
        
        let trackHeight: CGFloat = 2.0
        let trackImage = UIImage.createImage(withColor: AppColor.purple30!, size: CGSize(width: 1, height: trackHeight))
        self.setMinimumTrackImage(trackImage, for: .normal)
        self.setMaximumTrackImage(trackImage, for: .normal)
        
        minimumValue = stepValues.first ?? 20
        maximumValue = stepValues.last ?? 100
        value = stepValues[2]
        
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
    
    // MARK: - Update Thumb Position
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
