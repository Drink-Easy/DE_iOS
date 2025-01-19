// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import CoreModule
import SwiftyToaster

public class ResultViewController: UIViewController {
    lazy var surveyResultTextView = SurveyResultTextView()

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
        
        view.addSubview(surveyResultTextView)
        surveyResultTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(120) // 명시적인 높이 설정
        }
        surveyResultTextView.setLabel(result: "김도연", commonText: "님께\n어울리는 와인은")
        
//        self.surveyResultTextView.removeBlurEffect()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
//            self.surveyResultTextView.addBlurEffect()
//        }
    }

}
