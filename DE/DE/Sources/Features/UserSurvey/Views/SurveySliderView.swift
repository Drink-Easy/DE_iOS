// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import CoreModule

class SurveySliderView: UIView {

    private var surveyTopView: SurveyTopView
    
    public var sliderView = CustomStepSlider(text1: "~5만원", text2: "5~10만원", text3: "10~15만원", text4: "15~20만원", text5: "20만원~", step1: 5, step2: 10, step3: 15, step4: 20, step5: 25).then {
        $0.isUserInteractionEnabled = true
    }
    
    public var nextButton: CustomButton
    
    init(titleText: String, currentPage: Int, entirePage: Int, buttonTitle: String) {
        self.surveyTopView = SurveyTopView(currentPage: currentPage, entirePage: entirePage)
        surveyTopView.setTitleLabel(titleText)
        self.nextButton = CustomButton(title: buttonTitle, titleColor: .white, isEnabled: false).then {
            $0.isEnabled = false
        }
        
        super.init(frame: .zero)
        backgroundColor = AppColor.bgGray
        self.addComponents()
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        [surveyTopView, sliderView, nextButton].forEach{ addSubview($0) }
    }
    
    private func constraints() {
        surveyTopView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(10.0))
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        sliderView.snp.makeConstraints {
            $0.top.equalTo(surveyTopView.snp.bottom).offset(94)
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(22)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(DynamicPadding.dynamicValue(28.0))
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-DynamicPadding.dynamicValue(42.0))
        }
    }
}
