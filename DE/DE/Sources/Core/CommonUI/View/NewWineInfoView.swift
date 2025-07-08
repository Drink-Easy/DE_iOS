// Copyright © 2025 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import DesignSystem

public class NewWineInfoView: UIView {
    
    // MARK: - UI Components 선언
    private lazy var wineImage = WineImageView()
    public lazy var wineInfo = WineSummaryView()
    
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
        [wineImage, wineInfo].forEach{ self.addSubview($0) }
    }
    
    // MARK: - Setup Layout
    private func setupLayout() {
        // 레이아웃 설정
        wineImage.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(23)
            $0.width.height.equalTo(DynamicPadding.dynamicValue(330))
            $0.centerX.equalToSuperview()
        }
        wineInfo.snp.makeConstraints {
            $0.top.equalTo(wineImage.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(23)
        }
    }
    
    // MARK: - Configure
    public func configure(_ model: WineDetailInfoModel) {
        // 뷰 설정
        wineImage.configure(imageURL: model.image)
        wineInfo.configure(model)
    }
}
