// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import SnapKit
import Then

class NewbieConsumeViewController: UIViewController {
    
    private let navigationBarManager = NavigationBarManager()
    
    private var selectedItem: Float?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = surveySliderView
        surveySliderView.nextButton.isEnabled = true
        surveySliderView.nextButton.isEnabled(isEnabled: true)
        setupNavigationBar()
        
        UserSurveyManager.shared.union()
        UserSurveyManager.shared.intersection()
        
//        print("====합집합====")
//        print("\(UserSurveyManager.shared.getUnionVarietyData().count)")
//        print("\(UserSurveyManager.shared.getUnionSortData().count)")
//        
//        print("====교집합====")
//        print("\(UserSurveyManager.shared.getIntersectionVarietyData().count)")
//        print("\(UserSurveyManager.shared.getIntersectionSortData().count)")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private var surveySliderView = SurveySliderView(titleText: "추천 받고싶은\n와인의 금액대를 알려주세요.", currentPage: 3, entirePage: 3, buttonTitle: "추천 결과 확인하기").then {
        
        $0.sliderView.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        $0.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        selectedItem = sender.value
        
        // 버튼 원래부터 enable로
//        surveySliderView.nextButton.isEnabled = true
//        surveySliderView.nextButton.isEnabled(isEnabled: true)
    }
    
    @objc func nextButtonTapped() {
        // 정보 저장
        guard let price = self.selectedItem else {return}
        UserSurveyManager.shared.setPrice(Int(price))
        
        let vc = NormalTextViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
