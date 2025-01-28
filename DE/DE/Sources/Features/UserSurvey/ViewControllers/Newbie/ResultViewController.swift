// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import CoreModule
import SwiftyToaster

public class ResultViewController: UIViewController {
    private let navigationBarManager = NavigationBarManager()
    
    lazy var surveyResultTextView1 = SurveyResultTextView()
    lazy var surveyResultTextView2 = SurveyResultTextView()
    lazy var surveyResultTextView3 = SurveyResultTextView()

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        
        let varietyData = UserSurveyManager.shared.getIntersectionVarietyData()
        var varietyString: String = ""
        if varietyData.count < 3 {
            varietyData.forEach {
                varietyString += $0
                varietyString += ", "
            }
        } else {
            for i in 0...2 {
                varietyString += varietyData[i] + ", "
            }
        }
        
        surveyResultTextView1.setLabel(result: "드링이", commonText: "님께\n어울리는 와인은")
        surveyResultTextView2.setLabel(result: "\(varietyString)", commonText: "품종의")

        setUI()
        setupNavigationBar()
        
    }
    
    func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    func setUI() {
        [surveyResultTextView1, surveyResultTextView2, surveyResultTextView3].forEach{ view.addSubview($0) }
        
        surveyResultTextView1.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(120) // 명시적인 높이 설정
        }
        
        surveyResultTextView2.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(surveyResultTextView1.snp.bottom).offset(20)
            make.height.equalTo(120) // 명시적인 높이 설정
        }
        
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    

}
