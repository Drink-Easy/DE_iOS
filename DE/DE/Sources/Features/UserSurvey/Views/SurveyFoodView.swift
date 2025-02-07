// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import CoreModule

class SurveyFoodView: UIView {

    private var surveyTopView: SurveyTopView
    
    public lazy var surveyFoodCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 12
        $0.scrollDirection = .vertical
        $0.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }).then {
        $0.register(SurveyFoodCollectionViewCell.self, forCellWithReuseIdentifier: SurveyFoodCollectionViewCell.identifier)
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = false
        $0.allowsMultipleSelection = true
        $0.layer.cornerRadius = 10
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
        [surveyTopView, surveyFoodCollectionView, nextButton].forEach{ addSubview($0) }
    }
    
    private func constraints() {
        surveyTopView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(10.0))
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        surveyFoodCollectionView.snp.makeConstraints {
            $0.top.equalTo(surveyTopView.snp.bottom).offset(DynamicPadding.dynamicValue(40.0))
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(DynamicPadding.dynamicValue(24.0))
            $0.bottom.equalTo(nextButton.snp.top).offset(-12)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(DynamicPadding.dynamicValue(28.0))
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-DynamicPadding.dynamicValue(42.0))
        }
    }
}
