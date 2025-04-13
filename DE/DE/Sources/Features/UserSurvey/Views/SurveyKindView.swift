// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import CoreModule

class SurveyKindView: UIView {
    
    private var surveyTopView: SurveyTopView
    
    public lazy var surveyKindCollectionView = UICollectionView(frame: .zero, collectionViewLayout: LeftAlignedCollectionViewFlowLayout().then {
        $0.minimumInteritemSpacing = 6
        $0.minimumLineSpacing = 16
    }).then {
        $0.register(SurveyKindCollectionViewCell.self, forCellWithReuseIdentifier: SurveyKindCollectionViewCell.identifier)
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.allowsMultipleSelection = true
        $0.clipsToBounds = false
    }
    
    public var nextButton: CustomButton
    
    init(titleText: String, currentPage: Int, entirePage: Int, buttonTitle: String) {
        self.surveyTopView = SurveyTopView(currentPage: currentPage, entirePage: entirePage)
        surveyTopView.setTitleLabel(titleText)
        self.nextButton = CustomButton(title: buttonTitle, titleColor: .white, isEnabled: false).then {
            $0.isEnabled = false
        }
        
        super.init(frame: .zero)
        backgroundColor = AppColor.background
        self.addComponents()
        self.constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        [surveyTopView, surveyKindCollectionView, nextButton].forEach{ addSubview($0) }
    }
    
    private func constraints() {
        surveyTopView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(10.0))
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        surveyKindCollectionView.snp.makeConstraints {
            $0.top.equalTo(surveyTopView.snp.bottom).offset(DynamicPadding.dynamicValue(50.0))
            $0.leading.equalTo(safeAreaLayoutGuide).offset(DynamicPadding.dynamicValue(20.0))
            $0.trailing.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(400)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(DynamicPadding.dynamicValue(28.0))
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(-DynamicPadding.dynamicValue(42.0))
        }
    }
}
