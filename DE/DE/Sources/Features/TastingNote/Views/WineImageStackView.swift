// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import CoreModule

class WineImageStackView: UIStackView {
    
    var counts: [String: Int] = [
        "레드": 0,
        "화이트": 0,
        "스파클링": 0,
        "로제": 0,
        "기타": 0
    ]
    
    weak var delegate: WineImageStackViewDelegate?
    
    init() {
        super.init(frame: .zero)
        self.axis = .horizontal
        self.alignment = .center
        self.spacing = 10
        self.distribution = .fillEqually
        
        setupUI()
    }
    
    private func setupUI() {
        updateUI()
    }
    
    func updateUI() {
        
        self.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (imageName, imageLabel) in ImageStackView().images {
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 10
            imageView.isUserInteractionEnabled = true
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            imageView.addGestureRecognizer(tapGesture) // 탭 제스처 추가
            imageView.accessibilityLabel = imageLabel
            
            let label = UILabel()
            let count = counts[imageLabel] ?? 0
            let fullText = "\(imageLabel) \(count)"
            let coloredText = "\(count)"
//            let attributedString = fullText.withColor(for: coloredText, color: AppColor.purple100 ?? UIColor(hex: "#7E13B1")!)
//            label.attributedText = attributedString
//            label.font = UIFont(name: "Pretendard-Regular", size: 12)
            let attributedString = NSMutableAttributedString(
                string: fullText,
                attributes: [.font: UIFont.ptdRegularFont(ofSize: 12)]
            )
     
            if let range = fullText.range(of: coloredText) {
                let nsRange = NSRange(range, in: fullText)
                attributedString.addAttributes([
                    .font: UIFont.ptdSemiBoldFont(ofSize: 16),
                    .foregroundColor: AppColor.purple100 ?? UIColor(hex: "#7E13B1")!
                ], range: nsRange)
            }
            
            label.attributedText = attributedString
            
            let subStackView = UIStackView()
            subStackView.axis = .vertical
            subStackView.alignment = .center
            subStackView.spacing = 8
            subStackView.addArrangedSubview(imageView)
            subStackView.addArrangedSubview(label)
            
            imageView.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(imageView.snp.width)
            }
            
            label.snp.makeConstraints { make in
                make.top.equalTo(imageView.snp.bottom).offset(8)
                // make.leading.equalTo(imageView.snp.leading).offset(13)
                make.centerX.equalTo(imageView.snp.centerX)
            }
            
            self.addArrangedSubview(subStackView)
        }
    }
    
    func updateCounts(red: Int, white: Int, sparkling: Int, rose: Int, etc: Int) {
        // 데이터 업데이트
        counts = [
            "레드": red,
            "화이트": white,
            "스파클링": sparkling,
            "로제": rose,
            "기타": etc
        ]
        
        // UI 업데이트
        updateUI()
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let tappedImageView = gesture.view as? UIImageView,
              let category = tappedImageView.accessibilityLabel else { return }
        
        // 델리게이트 메서드 호출
        delegate?.didSelectWineSort(sort: category)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

protocol WineImageStackViewDelegate: AnyObject {
    func didSelectWineSort(sort: String)
}
