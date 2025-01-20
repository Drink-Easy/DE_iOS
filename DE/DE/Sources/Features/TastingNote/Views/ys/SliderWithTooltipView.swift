// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import CoreModule

import SnapKit
import Then
import AMPopTip

class SliderWithTooltipView: UIView {
    
    // MARK: - UI Components
    let titleLabel = UILabel().then {
        $0.textColor = AppColor.black
        $0.textAlignment = .left
        $0.font = UIFont.ptdMediumFont(ofSize: 18)
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
        $0.bubbleColor = AppColor.winebg?.withAlphaComponent(0.7) ?? .systemGray
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
        addSubview(titleLabel)
        addSubview(tooltipImage)
        addSubview(slider)
    }
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        tooltipImage.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.leading.equalTo(titleLabel.snp.trailing)
            make.width.height.equalTo(16)
        }
        
        slider.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.leading.equalTo(tooltipImage.snp.trailing).offset(23)
            make.trailing.equalToSuperview()
            make.width.equalTo(240)
        }
    }
    
    // MARK: - Actions
    @objc private func showTooltip() {
        guard let superview = self.superview else { return }
        let buttonFrame = self.convert(tooltipImage.frame, to: superview)
        
        tooltipPopTip.show(
//            font: UIFont.ptdMediumFont(ofSize: 12),
            text: tooltipText ?? "",
            direction: .down,
            maxWidth: 200,
            in: superview,
            from: buttonFrame
        )
    }
}
