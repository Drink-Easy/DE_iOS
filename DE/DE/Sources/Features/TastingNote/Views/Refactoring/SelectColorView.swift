// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

import SnapKit
import Then

class SelectColorView: UIView {
    public lazy var header = TopView(currentPage: 2, entirePage: 5)
    public lazy var infoView = DescriptionUIView().then{ d in
        d.layer.cornerRadius = 14
        d.backgroundColor = AppColor.white
    }
    public lazy var propertyHeader = PropertyTitleView(engName: "Color", korName: "색상")
    
    public lazy var nextButton = CustomButton(title: "다음", isEnabled: false)

    required init? (coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        addComponents()
        setConstraints()
    }
    
    public func setWineName(_ name: String) {
        self.header.setTitleLabel(name)
    }
    
    private func addComponents() {
        [surveyTopView, nextButton].forEach{ addSubview($0) }
    }
    
    private func setConstraints() {
        surveyTopView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(10)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(28)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-42)
        }
    }
    
}
