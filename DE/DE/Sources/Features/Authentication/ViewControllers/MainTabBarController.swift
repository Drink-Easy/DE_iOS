// Copyright © 2024 DRINKIG. All rights reserved

import UIKit
import CoreModule

public class MainTabBarController: UITabBarController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        configureTabs()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tabFrame = tabBar.frame
        tabBar.frame = tabFrame
    }
    
    public func configureTabs() {
        let nav1 = UINavigationController(rootViewController: HomeViewController())
        let nav2 = UINavigationController(rootViewController: AllTastingNoteVC())
        let nav3 = UINavigationController(rootViewController: SettingMenuViewController())
        
        let home = UIImage(systemName: "house.fill")
        let note = UIImage(systemName: "book.fill")
        let setting = UIImage(systemName: "person.fill")

        nav1.tabBarItem = UITabBarItem(title: "홈", image: home, tag: 0)
        nav2.tabBarItem = UITabBarItem(title: "테이스팅 노트", image: note, tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "마이", image: setting, tag: 2)
        
        if traitCollection.userInterfaceStyle == .light {
            UITabBar.clearShadow()
            tabBar.layer.applyShadow(color: .gray, alpha: 0.3, x: 0, y: 0, blur: 15)
        } else {
            // 다크모드에서는 그림자 제거
            tabBar.layer.shadowOpacity = 0
        }
        
        tabBar.tintColor = .label
        tabBar.backgroundColor = AppColor.white
        
        tabBar.tintColor = UIColor(named: "purple100")
        tabBar.unselectedItemTintColor = UIColor(named: "gray50")
        setViewControllers([nav1, nav2, nav3], animated: true)
    }
}
// MARK: - UITabBarControllerDelegate
extension MainTabBarController: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // 현재 선택된 탭이 다시 선택되었을 때만 처리
        guard let navController = viewController as? UINavigationController else { return }
        
        // 루트 뷰로 이동
        navController.popToRootViewController(animated: true)
    }
}
