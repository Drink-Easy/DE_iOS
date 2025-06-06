// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import CoreModule
import DesignSystem
import Then

class MyNoteTopView: UIView {
    public lazy var header = UILabel().then {
        $0.textColor = AppColor.black
        $0.font = UIFont.pretendard(.semiBold, size: 24)
        $0.numberOfLines = 0
    }
    
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
    
    public func setWineName(_ name: String) {
        self.header.text = name
    }
    
    private func setConstraints() {
        header.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        infoView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(DynamicPadding.dynamicValue(20))
            make.leading.trailing.equalToSuperview()
        }
    }
}
