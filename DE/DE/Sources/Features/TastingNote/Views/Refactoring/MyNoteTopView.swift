// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import CoreModule
import Then

class MyNoteTopView: UIView {
    public lazy var header = UILabel().then {
        $0.textColor = AppColor.black
        $0.font = UIFont.ptdSemiBoldFont(ofSize: 24)
        $0.numberOfLines = 0
    }
    public lazy var infoView = WineDetailView()

    // 버튼
//    public lazy var button = CustomButton(title: "저장하기", isEnabled: true)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addComponents()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setTitleLabel(_ text: String) {
        self.header.text = text
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
            make.top.equalTo(header.snp.bottom).offset(20) // TODO : 동적 기기 대응
            make.leading.trailing.equalToSuperview()
        }
    }
}
