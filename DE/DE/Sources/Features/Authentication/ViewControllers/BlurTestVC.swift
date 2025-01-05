// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit

class BlurTestVC: UIViewController {
    
    // 라벨 및 블러 뷰 배열 생성
    private var labels: [UILabel] = []
    private var blurViews: [UIVisualEffectView] = []
    
    // 버튼 추가
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("애니메이션 시작", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = UIColor.systemPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.isEnabled = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLabels()
        setupBlurViews()
        setupButton()
    }
    
    // MARK: - 라벨 설정
    private func setupLabels() {
        for i in 1...3 {
            let label = UILabel()
            label.text = "라벨 \(i)"
            label.textAlignment = .center
            label.font = UIFont.boldSystemFont(ofSize: 24)
            label.textColor = .black
            view.addSubview(label)
            labels.append(label)
            
            // SnapKit 적용
            label.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalToSuperview().offset(150 + (i - 1) * 100)
                make.width.equalTo(300)
                make.height.equalTo(50)
            }
        }
    }
    
    // MARK: - 블러 뷰 설정
    private func setupBlurViews() {
        for i in 0..<labels.count {
            let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
            view.addSubview(blurView)
            blurViews.append(blurView)
            
            // SnapKit 적용
            blurView.snp.makeConstraints { make in
                make.edges.equalTo(labels[i])
            }
        }
    }
    
    // MARK: - 버튼 설정
    private func setupButton() {
        view.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        // 버튼 클릭 시 애니메이션 시작
        actionButton.addTarget(self, action: #selector(startBlurAnimation), for: .touchUpInside)
    }
    
    // MARK: - 블러 애니메이션
    @objc private func startBlurAnimation() {
        // 버튼 비활성화
        actionButton.isEnabled = false
        actionButton.backgroundColor = UIColor.systemGray
        
        let totalSteps = labels.count + 1 // 3개 라벨 + 마지막 블러 제거 단계
        
        for step in 0..<totalSteps {
            UIView.animate(withDuration: 2.0, // 👉 애니메이션 시간 연장 (2.0초 × 3회 = 6초)
                           delay: Double(step) * 1.5, // 👉 딜레이 추가로 자연스러운 효과
                           options: .curveEaseInOut) {
                
                if step < self.labels.count {
                    // 현재 라벨만 블러 해제
                    for (index, blurView) in self.blurViews.enumerated() {
                        blurView.alpha = index == step ? 0 : 1
                    }
                } else {
                    // 모든 블러 제거
                    for blurView in self.blurViews {
                        blurView.alpha = 0
                    }
                }
                
            } completion: { finished in
                if step == totalSteps - 1 {
                    // 마지막 단계에서는 블러 뷰 제거
                    self.blurViews.forEach { $0.removeFromSuperview() }
                    
                    // 버튼 다시 활성화
                    self.actionButton.isEnabled = true
                    self.actionButton.backgroundColor = UIColor.systemPurple
                }
            }
        }
    }
}
