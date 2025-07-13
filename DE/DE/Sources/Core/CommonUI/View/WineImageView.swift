// Copyright © 2025 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then

import DesignSystem

final class WineImageView: UIView {
    
    // MARK: - UI Components 선언
    private lazy var imageBackground = UIView().then {
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.backgroundColor = AppColor.white
    }

    // 실제 콘텐츠를 담는 뷰 (cornerRadius 적용)
    public lazy var image = UIImageView().then {
        $0.layer.cornerRadius = 12
        $0.layer.masksToBounds = true
        $0.contentMode = .scaleAspectFit
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // UI 요소 추가
        self.addSubview(imageBackground)
        imageBackground.addSubview(image)
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        // 레이아웃 설정
        imageBackground.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        image.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(3)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    // MARK: - Configure
    public func configure(imageURL: String?) {
            if let urlString = imageURL,
               let url = URL(string: urlString) {
                image.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
            } else {
                image.image = UIImage(named: "placeholder")
            }
        }
}
