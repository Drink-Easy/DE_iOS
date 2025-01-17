// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule
import SnapKit
import Then

class ManiaConsumeViewController: UIViewController {
    
    private let navigationBarManager = NavigationBarManager()
    
    private var selectedItem: Float?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view = surveySliderView
        setupNavigationBar()
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
            action: #selector(backButtonTapped),
            tintColor: AppColor.gray70!
        )
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private var surveySliderView = SurveySliderView(titleText: "일주일 간 소비하시는\n와인 금액을 알려주세요", currentPage: 1, entirePage: 4, buttonTitle: "다음").then {
        
        $0.sliderView.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        $0.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        selectedItem = sender.value

        surveySliderView.nextButton.isEnabled = true
        surveySliderView.nextButton.isEnabled(isEnabled: true)
    }
    
    @objc func nextButtonTapped() {
        // 정보 저장
        guard let price = self.selectedItem else {return}
        UserSurveyManager.shared.setPrice(Int(price))
        
        let vc = ManiaKindViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
