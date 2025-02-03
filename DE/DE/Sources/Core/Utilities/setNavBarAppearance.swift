// Copyright © 2024 DRINKIG. All rights reserved

import UIKit

public func setNavBarAppearance(navigationController: UINavigationController?) {
    let standardAppearance = UINavigationBarAppearance()
    standardAppearance.configureWithOpaqueBackground()
    standardAppearance.backgroundColor = AppColor.bgGray
    standardAppearance.titleTextAttributes = [.foregroundColor: AppColor.black!]
    standardAppearance.shadowColor = .clear
    
    let scrollEdgeAppearance = UINavigationBarAppearance()
    scrollEdgeAppearance.configureWithOpaqueBackground()
    scrollEdgeAppearance.backgroundColor = AppColor.bgGray
    scrollEdgeAppearance.titleTextAttributes = [.foregroundColor: AppColor.black!]
    scrollEdgeAppearance.shadowColor = .clear
    
    navigationController?.navigationBar.standardAppearance = scrollEdgeAppearance
    navigationController?.navigationBar.scrollEdgeAppearance = standardAppearance
    navigationController?.navigationBar.compactAppearance = standardAppearance
}
