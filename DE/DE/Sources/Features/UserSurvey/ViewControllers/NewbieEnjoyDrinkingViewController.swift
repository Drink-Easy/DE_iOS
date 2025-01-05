// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import SnapKit
import Then
import CoreModule

class NewbieEnjoyDrinkingViewController: UIViewController {
    
    private let navigationBarManager = NavigationBarManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.bgGray
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
    
    private lazy var surveyTopView = SurveyTopView(titleText: "평소 즐겨마시는/n주종을 골라주세요(2개 ", currentPage: 1, entirePage: 3)
    
    private lazy var isNewbieCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 18
    }).then {
        $0.register(SurveyKindCollectionViewCell.self, forCellWithReuseIdentifier: SurveyKindCollectionViewCell.identifier)
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.allowsMultipleSelection = true
    }
    
    public lazy var nextButton = CustomButton(
        title: "다음",
        titleColor: .white,
        isEnabled: false
    ).then {
        $0.isEnabled = false
    }
}
