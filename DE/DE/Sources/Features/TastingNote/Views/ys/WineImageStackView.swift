// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import SnapKit

import CoreModule

class WineImageStackContainerView: UIView {
    
    // 라벨 정의
    private let wineLabel = UILabel().then {
        $0.text = "전체 0병"
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 20)
        $0.textColor = AppColor.black
    }
    
    // 카테고리별 병 수
    private var counts: [String: Int] = [
        "레드": 0,
        "화이트": 0,
        "스파클링": 0,
        "로제": 0,
        "기타": 0
    ]
    
    // 스택뷰 정의
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
        // wineLabel과 wineStackView를 추가
        addSubview(wineLabel)
        addSubview(wineStackView)
        
        // SnapKit 제약 조건 설정
        wineLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16) // 상단 여백
            make.leading.trailing.equalToSuperview().inset(16) // 좌우 여백
        }
        
        wineStackView.snp.makeConstraints { make in
            make.top.equalTo(wineLabel.snp.bottom).offset(16) // wineLabel 아래 배치
            make.leading.trailing.equalToSuperview().inset(16) // 좌우 여백
            make.bottom.equalToSuperview().offset(-16) // 하단 여백
        }
        
        // 초기 UI 업데이트
        updateUI()
    }
    
    private func updateUI() {
        // 기존 뷰 모두 제거
        wineStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 이미지와 라벨 추가
        let images: [(category: String, imageName: String)] = [
            ("레드", "redImage"),
            ("화이트", "whiteImage"),
            ("스파클링", "sparkImage"),
            ("로제", "roseImage"),
            ("기타", "etcImage")
        ]

        // 순서대로 순회
        for (category, imageName) in images {
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.isUserInteractionEnabled = true
            imageView.backgroundColor = AppColor.white
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            imageView.addGestureRecognizer(tapGesture)
            imageView.accessibilityLabel = category
            
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
            
            // 세로 스택뷰 생성
            let subStackView = UIStackView()
            subStackView.axis = .vertical
            subStackView.alignment = .center
            subStackView.spacing = 8
            subStackView.addArrangedSubview(imageView)
            subStackView.addArrangedSubview(label)
            
            // 이미지 크기 제약 설정
            imageView.snp.makeConstraints { make in
                make.width.equalToSuperview()
                make.height.equalTo(imageView.snp.width)
            }
            
            // 레이블 제약 설정
            label.snp.makeConstraints { make in
                make.top.equalTo(imageView.snp.bottom).offset(8)
                make.centerX.equalTo(imageView.snp.centerX)
            }
            
            // 메인 스택뷰에 추가
            wineStackView.addArrangedSubview(subStackView)
        }
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let tappedImageView = gesture.view as? UIImageView,
              let category = tappedImageView.accessibilityLabel else { return }
        
        print("Selected category: \(category)")
        // 필요한 경우 델리게이트나 클로저로 이벤트 전달 가능
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
        
        // 전체 병 수 계산
        let total = red + white + sparkling + rose + etc
        wineLabel.text = "전체 \(total) 병"
        
        // UI 업데이트
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
