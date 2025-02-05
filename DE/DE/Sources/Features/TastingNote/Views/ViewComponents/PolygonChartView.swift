// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SwiftUI

import CoreModule

import SnapKit
import Then

class PolygonChartView: UIView {
    
    // MARK: - UI Components
    var viewModel = PalateViewModel()
    
    lazy var palateChart = PalateChartView(viewModel: viewModel)
    
    lazy var hostingController: UIHostingController<PalateChartView> = {
        let hostingController = UIHostingController(rootView: palateChart)
        hostingController.view.backgroundColor = .clear
        return hostingController
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupSubviews()
    }
    
    // MARK: - Setup Methods
    private func setupSubviews() {   // 헤더 추가
        addSubview(hostingController.view)  // 차트 뷰 추가
        
        hostingController.view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16) // 아래 여백
        }
    }
}
