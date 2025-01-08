// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

import SnapKit
import Then

import CoreModule
import Network

class AccountInfoViewController: UIViewController {
    
    let navigationBarManager = NavigationBarManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    // MARK: - UI Setup
    private func setupNavigationBar() {
        navigationBarManager.setTitle(to: navigationItem, title: "내 정보", textColor: AppColor.black!)
        navigationBarManager.addLeftRightButtons(to: navigationItem, leftIcon: "chevron.left", leftAction: #selector(backButtonTapped), rightIcon: "pencil", rightAction: #selector(backButtonTapped), target: self, tintColor: AppColor.gray70 ?? .gray)
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func goToProfileEditView() {
//        let loginViewController = LoginVC()
//        navigationController?.pushViewController(loginViewController, animated: true)
    }
    
}
