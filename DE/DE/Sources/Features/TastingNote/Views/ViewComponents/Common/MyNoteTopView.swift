// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import CoreModule
import Then

class MyNoteTopView: UIView {
    public lazy var header = WineNameView()
    
    public lazy var infoView = WineDetailView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addComponents() {
        [header, infoView].forEach{ addSubview($0) }
    }
    
    private func setConstraints() {
        header.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(62)
        }
        
        infoView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(DynamicPadding.dynamicValue(20))
            make.leading.trailing.equalToSuperview()
        }
    }
}
