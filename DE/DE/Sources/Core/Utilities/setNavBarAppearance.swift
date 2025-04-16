// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import DesignSystem

public func setNavBarAppearance(navigationController: UINavigationController?) {
    let standardAppearance = UINavigationBarAppearance()
    standardAppearance.configureWithOpaqueBackground()
    standardAppearance.backgroundColor = AppColor.background
    standardAppearance.titleTextAttributes = [.foregroundColor: AppColor.black]
    standardAppearance.shadowColor = .clear
    
    let scrollEdgeAppearance = UINavigationBarAppearance()
    scrollEdgeAppearance.configureWithOpaqueBackground()
    scrollEdgeAppearance.backgroundColor = AppColor.background
    scrollEdgeAppearance.titleTextAttributes = [.foregroundColor: AppColor.black]
    scrollEdgeAppearance.shadowColor = .clear
    
    navigationController?.navigationBar.standardAppearance = scrollEdgeAppearance
    navigationController?.navigationBar.scrollEdgeAppearance = standardAppearance
    navigationController?.navigationBar.compactAppearance = standardAppearance
}
