// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import CoreModule
import DesignSystem

import SnapKit
import Then
import AMPopTip

class SliderWithTooltipView: UIView {
    
    // MARK: - UI Components
    let labelView = UIView()
    
    let titleLabel = UILabel().then {
        $0.textColor = AppColor.black
        $0.textAlignment = .left
        $0.font = .pretendard(.medium, size: 18)
    }

    let tooltipImage = UIImageView().then {
        $0.image = UIImage(systemName: "info.circle") // 이미지를 설정
        $0.tintColor = AppColor.gray50 // 색상 설정
        $0.isUserInteractionEnabled = true
    }

    let slider = CustomStepSlider().then {
        $0.isUserInteractionEnabled = true
    }

    let tooltipPopTip = PopTip().then {
        $0.bubbleColor = AppColor.tooltipBackground.withAlphaComponent(0.7)
        $0.arrowSize = CGSize(width: 12, height: 10)
        $0.arrowRadius = 3
        $0.padding = 10.0
        $0.textAlignment = .center
        $0.cornerRadius = 10
    }
    
    // MARK: - Properties
    var tooltipText: String? {
        didSet {
            tooltipPopTip.text = tooltipText
        }
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        setupConstraints()
        tooltipImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTooltip)))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
        setupConstraints()
        tooltipImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showTooltip)))
    }
    
    // MARK: - Setup Methods
    private func setupSubviews() {
        labelView.addSubview(titleLabel)
        labelView.addSubview(tooltipImage)
        addSubview(labelView)
        addSubview(slider)
    }
    
    private func setupConstraints() {
        labelView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.greaterThanOrEqualTo(16)
            make.width.equalToSuperview().multipliedBy(0.25)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        tooltipImage.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.leading.equalTo(titleLabel.snp.trailing).offset(6)
            make.width.height.equalTo(16)
        }
        
        slider.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.leading.equalTo(labelView.snp.trailing)
            make.trailing.equalToSuperview().inset(6)
            make.height.equalTo(80)
        }
    }
    
    // MARK: - Actions
    @objc private func showTooltip() {
        guard let superview = self.superview else { return }

        // 버튼 프레임을 superview 좌표계로 변환
        let buttonFrame = self.convert(tooltipImage.frame.offsetBy(dx: 0, dy: 55), to: superview)

        // 기본 폰트 적용 (폰트는 원하는 대로 교체 가능)
        let font = UIFont.pretendard(.medium, size: 12)
        let textColor = UIColor.white

        // NSAttributedString 생성
        let tooltipAttributedText = NSAttributedString(
            string: tooltipText ?? "",
            attributes: [
                .font: font,
                .foregroundColor: textColor
            ]
        )

        // 팝팁 표시 (Superview를 기준으로 설정)
        tooltipPopTip.show(
            attributedText: tooltipAttributedText,
            direction: .down,
            maxWidth: 200,
            in: superview, // `tooltipImage`의 상위 뷰에 팝팁 추가
            from: buttonFrame,
            duration: 3.0
        )
    }
}
