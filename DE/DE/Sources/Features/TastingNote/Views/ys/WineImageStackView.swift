// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import CoreModule

protocol WineSortDelegate: AnyObject {
    func didTapSortButton(for type: WineSortType)
}

enum WineSortType {
    case all, red, white, sparkling, rose, etc
}

class WineImageStackContainerView: UIView {
    
    weak var delegate: WineSortDelegate?
    
    private var selectedCategory: String?
    private var selectedImageView: UIImageView? // ✅ 선택된 이미지 추적
    
    private let wineLabel = UILabel().then {
        $0.text = "전체 0병"
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 20)
        $0.textColor = AppColor.black
    }
    
    private var counts: [String: Int] = [
        "레드": 0,
        "화이트": 0,
        "스파클링": 0,
        "로제": 0,
        "기타": 0
    ]
    
    private let wineStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 10
        $0.distribution = .fillEqually
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(wineLabel)
        addSubview(wineStackView)
        
        wineLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
        }
        
        wineStackView.snp.makeConstraints { make in
            make.top.equalTo(wineLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        updateUI()
    }
    
    private func updateUI() {
        wineStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let images: [(category: String, imageName: String)] = [
            ("레드", "redImage"),
            ("화이트", "whiteImage"),
            ("스파클링", "sparkImage"),
            ("로제", "roseImage"),
            ("기타", "etcImage")
        ]

        for (category, imageName) in images {
            let backgroundView = UIView()
            backgroundView.layer.shadowColor = AppColor.black?.cgColor
            backgroundView.layer.shadowOpacity = 0.1
            backgroundView.layer.shadowOffset = CGSize(width: 5, height: 5)
            backgroundView.layer.shadowRadius = 10
            backgroundView.backgroundColor = .clear

            let contentView = UIView()
            contentView.layer.cornerRadius = 10
            contentView.backgroundColor = AppColor.white
            contentView.layer.masksToBounds = true
            backgroundView.addSubview(contentView)
            
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 10
            imageView.layer.borderWidth = 2
            imageView.layer.borderColor = UIColor.clear.cgColor
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
            imageView.accessibilityLabel = category
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            imageView.addGestureRecognizer(tapGesture)
            
            let label = UILabel()
            let count = counts[category] ?? 0
            let fullText = "\(category) \(count)"
            let coloredText = "\(count)"
            let attributedString = NSMutableAttributedString(
                string: fullText,
                attributes: [.font: UIFont.ptdRegularFont(ofSize: 12)]
            )
            
            if let range = fullText.range(of: coloredText) {
                let nsRange = NSRange(range, in: fullText)
                attributedString.addAttributes([
                    .font: UIFont.ptdSemiBoldFont(ofSize: 16),
                    .foregroundColor: AppColor.purple100!
                ], range: nsRange)
            }
            
            label.attributedText = attributedString
            label.textAlignment = .center
            
            let subStackView = UIStackView()
            subStackView.axis = .vertical
            subStackView.alignment = .center
            subStackView.spacing = 8
            contentView.addSubview(imageView)
            subStackView.addArrangedSubview(backgroundView)
            subStackView.addArrangedSubview(label)
            
            backgroundView.snp.makeConstraints { make in
                make.width.height.equalTo(60)
            }
            contentView.snp.makeConstraints { make in
                make.width.height.equalTo(60)
            }
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(60)
                make.centerX.centerY.equalToSuperview()
            }
            label.snp.makeConstraints { make in
                make.top.equalTo(backgroundView.snp.bottom).offset(8)
                make.centerX.equalTo(backgroundView.snp.centerX)
            }
            
            wineStackView.addArrangedSubview(subStackView)
        }
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let tappedImageView = gesture.view as? UIImageView,
              let category = tappedImageView.accessibilityLabel else { return }
        
        if selectedCategory == category {
            // ✅ 선택 해제
            tappedImageView.layer.borderColor = UIColor.clear.cgColor
            selectedCategory = nil
            selectedImageView = nil
            delegate?.didTapSortButton(for: .all)
        } else {
            // ✅ 기존 선택 해제 후 새 선택 적용
            selectedImageView?.layer.borderColor = UIColor.clear.cgColor
            tappedImageView.layer.borderColor = AppColor.purple100?.cgColor
            selectedCategory = category
            selectedImageView = tappedImageView
            
            let sortType = getWineSortType(from: category)
            delegate?.didTapSortButton(for: sortType)
        }
    }
    
    private func getWineSortType(from category: String) -> WineSortType {
        switch category {
        case "레드": return .red
        case "화이트": return .white
        case "스파클링": return .sparkling
        case "로제": return .rose
        default: return .etc
        }
    }
    
    func updateCounts(red: Int, white: Int, sparkling: Int, rose: Int, etc: Int) {
        counts = [
            "레드": red,
            "화이트": white,
            "스파클링": sparkling,
            "로제": rose,
            "기타": etc
        ]
        
        let total = red + white + sparkling + rose + etc
        wineLabel.text = "전체 \(total)병"
        
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
